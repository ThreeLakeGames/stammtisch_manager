import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class StammtischListData with ChangeNotifier {
  List<StammtischItemData> clubList = [];
  StreamSubscription<QuerySnapshot>? _streamSubscription;

//fetch all clubs where the user is a member
  void setUpClubListener() {
    final userID = FirebaseAuth.instance.currentUser!.uid;
    _streamSubscription = FirebaseFirestore.instance
        .collection("stammtischList")
        .limit(100)
        .where("memberIDs", arrayContains: userID)
        .snapshots()
        .listen((snapshot) {
      clubList = [];
      for (final document in snapshot.docs) {
        clubList.add(
          StammtischItemData.fromFirestore(
            id: document.id,
            data: document.data(),
          ),
        );
      }
      notifyListeners();
    });
  }

  void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    print("deepLink:  $deepLink");

    if (deepLink != null) {
      handleDynamicLink(deepLink);
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      handleDynamicLink(dynamicLinkData.link);
    });

    // FirebaseDynamicLinks.instance.onLink(onSuccess: (_)async{
  }

  handleDynamicLink(Uri url) {
    List<String> separatedString = [];
    separatedString.addAll(url.pathSegments);
    print(separatedString);
    if (separatedString[0] == "invite") {
      print(
        "invite to clubID: ${separatedString[1]}",
      );
      final clubID = separatedString[1];
      tryToJoinClub(clubID);
    }
  }

  void tryToJoinClub(String id) {
    FirebaseFirestore.instance.doc("stammtischList/$id").update(
      {
        "memberIDs":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription!.cancel();
    super.dispose();
  }
}
