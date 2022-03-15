import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/event_item.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';
import 'package:stammtisch_manager/club_screens/events/new_event_screen.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class EventsOverviewScreen extends StatelessWidget {
  const EventsOverviewScreen({Key? key}) : super(key: key);

  void startAddNewEvent(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(NewEventScreen.routeName).then((result) {
      if (result == null) {
        return;
      }
      Provider.of<StammtischItemData>(ctx, listen: false)
          .addEventToList(result as EventModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventList = Provider.of<StammtischItemData>(context).events;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: eventList.length,
              itemBuilder: ((context, index) => EventItem(
                    eventData: eventList[index],
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  startAddNewEvent(context);
                },
                child: const Text("Termin hinzufügen")),
          )
        ],
      ),
    );
  }
}
