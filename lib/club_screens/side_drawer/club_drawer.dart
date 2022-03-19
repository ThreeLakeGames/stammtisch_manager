import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClubDrawer extends StatelessWidget {
  const ClubDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 24,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            height: 80,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: Text(
              "Optionen",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
          // Expanded(child: Text("test")),
          ClubDrawerItem(
            title: "zum Hauptmenu",
            icon: Icons.arrow_back,
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}

class ClubDrawerItem extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final IconData icon;
  const ClubDrawerItem({
    Key? key,
    required this.title,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: onTap,
            title: Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).textTheme.headlineMedium!.color,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
