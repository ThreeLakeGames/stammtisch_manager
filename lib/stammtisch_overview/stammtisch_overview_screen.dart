import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/provider/stammtisch_list_data.dart';
import 'package:stammtisch_manager/stammtisch_overview/stammtisch_overview_item.dart';

class StammtischOverviewScreen extends StatefulWidget {
  const StammtischOverviewScreen({Key? key}) : super(key: key);

  @override
  State<StammtischOverviewScreen> createState() =>
      _StammtischOverviewScreenState();
}

class _StammtischOverviewScreenState extends State<StammtischOverviewScreen> {
  @override
  void initState() {
    final clubListData =
        Provider.of<StammtischListData>(context, listen: false);
    clubListData.setUpClubListener();
    clubListData.initDynamicLinks();

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
