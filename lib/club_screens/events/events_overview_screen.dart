import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';
import 'package:stammtisch_manager/club_screens/events/event_overview_list.dart';
import 'package:stammtisch_manager/club_screens/events/new_event_screen.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class EventsOverviewScreen extends StatefulWidget {
  EventsOverviewScreen({Key? key}) : super(key: key);
  List<Widget> appBarActions = [];

  @override
  State<EventsOverviewScreen> createState() => _EventsOverviewScreenState();
}

class _EventsOverviewScreenState extends State<EventsOverviewScreen> {
  bool _isShowingUpComingEvents = true;
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _isShowingUpComingEvents = index == 0;
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final upcomingEventList =
        Provider.of<StammtischItemData>(context).upcomingEvents;
    final outdatedEventList =
        Provider.of<StammtischItemData>(context).outdatedEvents;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPageIndex,
          onTap: _selectPage,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.access_alarm), label: "Anstehend"),
            BottomNavigationBarItem(
                icon: Icon(Icons.free_cancellation), label: "Vergangen")
          ]),
      body: _isShowingUpComingEvents
          ? EventOverviewList(eventList: upcomingEventList)
          : EventOverviewList(eventList: outdatedEventList),
    );
  }
}
