import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';
import 'package:stammtisch_manager/provider/stammtisch_list_data.dart';
import 'package:stammtisch_manager/stammtisch_overview/stammtisch_overview_item.dart';

class StammtischOverviewScreen extends StatelessWidget {
  static const routeName = "/stammtisch-overview-screen";
  const StammtischOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stammtisch-Übersicht"),
      ),
      body: const StammtischOverviewList(),
    );
  }
}

class StammtischOverviewList extends StatefulWidget {
  const StammtischOverviewList({Key? key}) : super(key: key);

  @override
  State<StammtischOverviewList> createState() => _StammtischOverviewListState();
}

class _StammtischOverviewListState extends State<StammtischOverviewList> {
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
