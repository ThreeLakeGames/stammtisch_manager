import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class EventItem extends StatelessWidget {
  EventItem({Key? key, required this.eventData}) : super(key: key);
  final EventModel eventData;

  final List<PopupMenuItem<String>> _popUpItems = [
    PopupMenuItem<String>(
      child: Row(
        children: const [
          Icon(Icons.settings),
          Text("  bearbeiten"),
        ],
      ),
      value: "edit",
    ),
    PopupMenuItem<String>(
      child: Row(
        children: const [
          Icon(Icons.delete),
          Text(" entfernen"),
        ],
      ),
      value: "delete",
    ),
  ];

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
                }
              }), itemBuilder: (context) {
                return _popUpItems;
              })
            ],
          ),
        ),
      ),
    );
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
          child: Text(
            "Ort: ${eventData.location}",
            // style: Theme.of(ctx).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
