import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stammtisch_manager/auth/invitationLink.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class StammtischMemberScreen extends StatefulWidget {
  StammtischMemberScreen({Key? key}) : super(key: key);
  List<Widget> appBarActions = [];

  @override
  State<StammtischMemberScreen> createState() => _StammtischMemberScreenState();
}

class _StammtischMemberScreenState extends State<StammtischMemberScreen> {
  List<Widget> appBarActions = [];
  @override
  Widget build(BuildContext context) {
    final invitationLink =
        Provider.of<StammtischItemData>(context).invitationLink;
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              if (invitationLink == null) return;
              Share.share(
                  "Tritt mit diesem Link meiner Gruppe bei: $invitationLink");
            },
            child: const Text("create Invitation Link"),
          ),
          Text("invitation Link: $invitationLink"),
        ],
      ),
    );
  }
}
