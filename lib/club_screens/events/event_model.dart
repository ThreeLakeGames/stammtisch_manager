import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  DateTime date;
  RepeatEvent repeatEvent;
  String title;
  String location;
  String description;

  EventModel({
    required this.date,
    required this.title,
    required this.location,
    required this.description,
    required this.repeatEvent,
    required this.id,
  });

  factory EventModel.createNew() {
    return EventModel(
      date: DateTime.now(),
      title: "",
      location: "",
      description: "",
      id: "",
      repeatEvent: RepeatEvent.noRepeat,
    );
  }

  factory EventModel.fromJson(String id, Map<String, dynamic> data) {
    return EventModel(
      id: id,
      date: data["date"].toDate(),
      title: data["title"] ?? "",
      location: data["location"] ?? "",
      description: data["description"] ?? "",
      repeatEvent: RepeatEvent.noRepeat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "location": location,
      "description": description,
      "date": Timestamp.fromDate(date),
    };
  }

  bool get isInPast {
    return date.isBefore(DateTime.now());
  }
}

enum RepeatEvent {
  noRepeat,
  weekly,
  everyTwoWeeks,
  monthly,
}

extension RepeatEventExtension on RepeatEvent {
  String get title {
    switch (this) {
      case RepeatEvent.monthly:
        return "monatlich";
      case RepeatEvent.everyTwoWeeks:
        return "alle zwei Wochen";
      case RepeatEvent.weekly:
        return "wöchentlich";
      case RepeatEvent.noRepeat:
        return "einmalig";

      default:
        return "einmalig";
    }
  }
}
