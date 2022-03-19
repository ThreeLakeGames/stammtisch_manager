import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';

class StammtischItemData with ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? _streamSubscription;
  StreamSubscription<QuerySnapshot>? _eventsSubscription;

  List<EventModel> upcomingEvents = [];
  List<EventModel> outdatedEvents = [];

  List<String> memberIDs = [];

  List<Widget> appBarActions = [
    IconButton(onPressed: () {}, icon: const Icon(Icons.add))
  ];

  bool isListening = false;
  String id;
  String title;

  String get rootDocumentPath {
    return "stammtischList/$id";
  }

  String get eventsCollectionPath {
    return "$rootDocumentPath/termine";
  }

  StammtischItemData({
    required this.id,
    required this.title,
  });

  factory StammtischItemData.fromFirestore({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return StammtischItemData(
        id: id, title: data["stammtischTitle"] ?? "error");
  }

  void setUpListener() {
    if (isListening) {
      print("isListening is currently true");
      return;
    }
    isListening = true;
    _streamSubscription = FirebaseFirestore.instance
        .doc(rootDocumentPath)
        .snapshots()
        .listen((snapshot) {
      title = snapshot.data()!["stammtischTitle"] ?? "fail";
      notifyListeners();
    });
  }

//---------------------*EVENTS*---------------------------------------------------

  void setUpEventsListener() {
    _eventsSubscription = FirebaseFirestore.instance
        .collection(eventsCollectionPath)
        .orderBy("date")
        .snapshots()
        .listen((snapshot) {
      upcomingEvents = [];
      outdatedEvents = [];
      for (final document in snapshot.docs) {
        final date = document.data()["date"].toDate() as DateTime;
        if (date.isAfter(DateTime.now())) {
          upcomingEvents.add(EventModel.fromJson(document.id, document.data()));
        } else {
          outdatedEvents.add(EventModel.fromJson(document.id, document.data()));
        }
      }
      notifyListeners();
    });
  }

  void addEventToList(EventModel event) {
    FirebaseFirestore.instance
        .collection(eventsCollectionPath)
        .add(event.toJson());
  }

  DocumentReference<Map<String, dynamic>> getEventDocumentRef(String id) {
    return FirebaseFirestore.instance.doc(eventsCollectionPath + "/$id");
  }

  void deleteEvent(String id) {
    getEventDocumentRef(id).delete();
  }

  void editEvent(EventModel event) {
    getEventDocumentRef(event.id).update(event.toJson());
  }

//-------------------*MEMBER-MANAGEMENT*---------------------------------------------------

  void addMemberToClub(String id) {
    FirebaseFirestore.instance.doc(rootDocumentPath).update(
      {
        "memberIDs":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      },
    );
  }

  void setAppBarActions(List<Widget> actions) {
    appBarActions = actions;
    notifyListeners();
  }

  @override
  void dispose() {
    print("cancel Listener");
    _streamSubscription!.cancel();
    _eventsSubscription!.cancel();
    super.dispose();
  }
}
