import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/new_event_screen.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';
import 'package:stammtisch_manager/provider/stammtisch_list_data.dart';
import 'package:stammtisch_manager/stammtisch_overview/stammtisch_overview_item.dart';
import 'package:stammtisch_manager/stammtisch_overview/new_stammtisch_screen.dart';

class StammtischOverviewScreen extends StatefulWidget {
  const StammtischOverviewScreen({Key? key}) : super(key: key);

  @override
  State<StammtischOverviewScreen> createState() =>
      _StammtischOverviewScreenState();
}

class _StammtischOverviewScreenState extends State<StammtischOverviewScreen> {
  @override
  void initState() {
    Provider.of<StammtischListData>(context, listen: false).setUpClubListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clubList = Provider.of<StammtischListData>(context).clubList;
    return ListView.builder(
        itemCount: clubList.length,
        itemBuilder: (ctx, i) {
          return StammtischOverviewItem(stammtischData: clubList[i]);
        });
  }
}
