import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  DateTime date;
  RepeatEvent repeatEvent;
  String title;
  String location;
  String description;
  int repeatingCount;

  EventModel({
    required this.date,
    required this.title,
    required this.location,
    required this.description,
    required this.repeatEvent,
    required this.id,
    required this.repeatingCount,
  });

  factory EventModel.createNew() {
    final DateTime initDate = DateTime.now();
    const int initHour = 19;

    return EventModel(
      date: DateTime(
        initDate.year,
        initDate.month,
        initDate.day,
        initHour,
      ),
      title: "",
      location: "",
      description: "",
      id: "",
      repeatEvent: RepeatEvent.noRepeat,
      repeatingCount: 1,
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
      repeatingCount: 1,
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

// returns new DateTime based on the repetion setting.
// this is used to get the proper dates, when you add repeated events.
  DateTime getRepeatedEventDate(DateTime date, int repeatCount) {
    switch (this) {
      case RepeatEvent.monthly:
        return DateTime(date.year, date.month + 1 * repeatCount, date.day,
            date.hour, date.minute);
      case RepeatEvent.everyTwoWeeks:
        return DateTime(date.year, date.month, date.day + 14 * repeatCount,
            date.hour, date.minute);
      case RepeatEvent.weekly:
        return DateTime(date.year, date.month, date.day + 7 * repeatCount,
            date.hour, date.minute);
      case RepeatEvent.noRepeat:
        return date;

      default:
        return date;
    }
  }
}
