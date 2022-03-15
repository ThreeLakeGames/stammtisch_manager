import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class StammtischListData with ChangeNotifier {
  List<StammtischItemData> clubList = [];
  StreamSubscription<QuerySnapshot>? _streamSubscription;

  void setUpClubListener() {
    _streamSubscription = FirebaseFirestore.instance
        .collection("stammtischList")
        .limit(100)
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

  @override
  void dispose() {
    _streamSubscription!.cancel();
    super.dispose();
  }
}
