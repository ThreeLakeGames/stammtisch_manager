import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';
import 'package:stammtisch_manager/club_screens/events/new_event_screen.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class NewEventButton extends StatelessWidget {
  const NewEventButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        startAddNewEvent(context);
      },
      icon: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }

  void addNewEvents(BuildContext ctx, EventModel event) {
    final stammtischItemProvider =
        Provider.of<StammtischItemData>(ctx, listen: false);
    if (event.repeatEvent == RepeatEvent.noRepeat) {
      stammtischItemProvider.addEventToList(event);
      return;
    }
    DateTime firstEventDate = event.date;
    for (var i = 0; i < event.repeatingCount; i++) {
      event.date = event.repeatEvent.getRepeatedEventDate(firstEventDate, i);
      stammtischItemProvider.addEventToList(event);
    }
  }

  void startAddNewEvent(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (context) => NewEventScreen.addEvent()),
    ).then((result) {
      if (result == null) {
        return;
      }
      addNewEvents(ctx, result as EventModel);
    });
  }
}
