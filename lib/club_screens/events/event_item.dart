import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';
import 'package:stammtisch_manager/club_screens/events/new_event_screen.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class EventItem extends StatelessWidget {
  EventItem({Key? key, required this.eventData}) : super(key: key);
  final EventModel eventData;

  List<PopupMenuItem<String>> _getPopUpItems(BuildContext ctx) {
    return [
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.edit,
              color: Theme.of(ctx).textTheme.bodyLarge!.color,
            ),
            Text(
              "  bearbeiten",
              style: Theme.of(ctx).textTheme.bodyLarge,
            ),
          ],
        ),
        value: "edit",
      ),
      PopupMenuItem<String>(
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: Theme.of(ctx).textTheme.bodyLarge!.color,
            ),
            Text(
              "  entfernen",
              style: Theme.of(ctx).textTheme.bodyLarge,
            ),
          ],
        ),
        value: "delete",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventData.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    _buildInfoContent(context),
                  ],
                ),
              ),
              PopupMenuButton<String>(onSelected: ((value) {
                if (value == "delete") {
                  Provider.of<StammtischItemData>(context, listen: false)
                      .deleteEvent(eventData.id);
                } else if (value == "edit") {
                  startAddNewEvent(context, eventData);
                }
              }), itemBuilder: (ctx) {
                return _getPopUpItems(ctx);
              })
            ],
          ),
        ),
      ),
    );
  }

  void startAddNewEvent(BuildContext ctx, EventModel eventData) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
          builder: (context) => NewEventScreen.editEvent(eventData)),
    ).then((result) {
      if (result == null) {
        return;
      }
      Provider.of<StammtischItemData>(ctx, listen: false)
          .editEvent(result as EventModel);
    });
  }

  Widget _buildInfoContent(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            children: [
              Text(
                DateFormat.yMMMMd().format(eventData.date),
                // style: Theme.of(ctx).textTheme.bodyLarge,
              ),
              if (eventData.isInPast) const Text(" (Vergangen)")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Text("Uhrzeit: ${DateFormat.Hm().format(eventData.date)}"
              // style: Theme.of(ctx).textTheme.bodyLarge,
              ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Text(
            "Ort: ${eventData.location}",
            // style: Theme.of(ctx).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
