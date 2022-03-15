import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';

class StammtischItemData with ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? _streamSubscription;
  StreamSubscription<QuerySnapshot>? _eventsSubscription;

  List<EventModel> upcomingEvents = [];
  List<EventModel> outdatedEvents = [];

  bool isListening = false;
  String id;
  String title;

  String get rootCollectionPath {
    return "stammtischList/$id";
  }

  String get eventsCollectionPath {
    return "$rootCollectionPath/termine";
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
        .doc(rootCollectionPath)
        .snapshots()
        .listen((snapshot) {
      title = snapshot.data()!["stammtischTitle"] ?? "fail";
      notifyListeners();
    });
  }

  void setUpEventsListener() {
    _eventsSubscription = FirebaseFirestore.instance
        .collection(eventsCollectionPath)
        .orderBy("date")
        .snapshots()
        .listen((snapshot) {
      upcomingEvents = [];
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
    print("added Event");
  }

  void deleteEvent(String id) {
    FirebaseFirestore.instance.doc(eventsCollectionPath + "/$id").delete();
  }

  @override
  void dispose() {
    print("cancel Listener");
    _streamSubscription!.cancel();
    _eventsSubscription!.cancel();
    super.dispose();
  }
}
