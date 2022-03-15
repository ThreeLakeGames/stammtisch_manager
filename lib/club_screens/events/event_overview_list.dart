import 'package:flutter/material.dart';
import 'package:stammtisch_manager/club_screens/events/event_item.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';

class EventOverviewList extends StatelessWidget {
  const EventOverviewList({
    Key? key,
    required this.eventList,
  }) : super(key: key);

  final List<EventModel> eventList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventList.length,
      itemBuilder: ((context, index) => EventItem(
            eventData: eventList[index],
          )),
    );
  }
}
