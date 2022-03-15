import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/events_overview_screen.dart';
import 'package:stammtisch_manager/club_screens/stammtisch_dashboard_screen.dart';
import 'package:stammtisch_manager/club_screens/stammtisch_member_screen.dart';
import 'package:stammtisch_manager/demoWidgets/calendar_demo_basic.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class StammtischTabsScreen extends StatefulWidget {
  static const routeName = "/stammtisch-tabs-screen";
  const StammtischTabsScreen({Key? key}) : super(key: key);

  @override
  State<StammtischTabsScreen> createState() => _StammtischTabsScreenState();
}

class _StammtischTabsScreenState extends State<StammtischTabsScreen> {
  late StammtischItemData stammtischData;
  bool isInit = false;
  final List<Map<String, dynamic>> _pages = const [
    {
      "page": StammtischDashboardScreen(),
      "title": "Dashboard",
    },
    {
      "page": StammtischMemberScreen(),
      "title": "Mitglieder",
    },
    {
      "page": EventsOverviewScreen(),
      "title": "Termine",
    },
    {
      "page": StammtischDashboardScreen(),
      "title": "Chat",
    },
    {
      "page": StammtischDashboardScreen(),
      "title": "Voting",
    }
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      final stammtischID = ModalRoute.of(context)!.settings.arguments as String;
      stammtischData = StammtischItemData(id: stammtischID, title: "");
      stammtischData.setUpListener();
      stammtischData.setUpEventsListener();
      isInit = true;
    }
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   initializeDateFormatting("de_DE", "");
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: stammtischData,
      child: Scaffold(
        appBar: AppBar(title: Text(_pages[_selectedPageIndex]["title"])),
        body: _pages[_selectedPageIndex]["page"],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedPageIndex,
          onTap: _selectPage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: "Mitglieder",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Termine",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.how_to_vote),
              label: "Voting",
            ),
          ],
        ),
      ),
    );
  }
}
