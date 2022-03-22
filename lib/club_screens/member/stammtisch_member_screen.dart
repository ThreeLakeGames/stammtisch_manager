import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class StammtischMemberScreen extends StatefulWidget {
  StammtischMemberScreen({Key? key}) : super(key: key);
  List<Widget> appBarActions = [];

  @override
  State<StammtischMemberScreen> createState() => _StammtischMemberScreenState();
}

class _StammtischMemberScreenState extends State<StammtischMemberScreen> {
  List<Widget> appBarActions = [];

  void shareInvitationLink(String? link) {
    if (link == null) return;
    Share.share("Tritt mit diesem Link meiner Gruppe bei: $link");
  }

  @override
  Widget build(BuildContext context) {
    final invitationLink =
        Provider.of<StammtischItemData>(context).invitationLink;
    return Center(
      child: ElevatedButton(
        onPressed: () {
          shareInvitationLink(invitationLink);
        },
        child: const Text("Freunde Einladen"),
      ),
    );
  }
}
