import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:stammtisch_manager/userProfile/profile_overview.dart';
import 'package:stammtisch_manager/stammtisch_overview/stammtisch_overview_screen.dart';
import 'package:stammtisch_manager/stammtisch_overview/new_stammtisch_screen.dart';
import 'package:stammtisch_manager/user_screens/invitations_screen.dart';

class MainTabsScreen extends StatefulWidget {
  MainTabsScreen({Key? key}) : super(key: key);

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _selectedPageIndex = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      "page": const StammtischOverviewScreen(),
      "title": "Stammtisch - Übersicht",
    },
    {
      "page": const ProfileOverview(),
      "title": "Profil",
    }
  ];
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]["title"]),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: _selectedPageIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NewStammtischScreen.routeName);
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: _pages[_selectedPageIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Übersicht",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
