import 'package:flutter/material.dart';
import 'package:stammtisch_manager/club_screens/stammtisch_dashboard_screen.dart';
import 'package:stammtisch_manager/club_screens/stammtisch_tabs_screen.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class StammtischOverviewItem extends StatelessWidget {
  const StammtischOverviewItem({Key? key, required this.stammtischData})
      : super(key: key);
  final StammtischItemData stammtischData;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListTile(
          title: Text(stammtischData.title),
          subtitle: Text(stammtischData.id),
          trailing: ElevatedButton(
            child: const Text("öffnen"),
            onPressed: () {
              Navigator.of(context).pushNamed(StammtischTabsScreen.routeName,
                  arguments: stammtischData.id);
            },
          ),
        ),
      ),
    );
  }
}
