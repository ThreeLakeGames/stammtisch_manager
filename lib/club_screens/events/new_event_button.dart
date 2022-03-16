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

  void startAddNewEvent(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (context) => NewEventScreen.addEvent()),
    ).then((result) {
      if (result == null) {
        return;
      }
      Provider.of<StammtischItemData>(ctx, listen: false)
          .addEventToList(result as EventModel);
    });
  }
}
