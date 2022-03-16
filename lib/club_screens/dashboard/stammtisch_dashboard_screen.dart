import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class StammtischDashboardScreen extends StatefulWidget {
  static const routeName = "/stammtisch-dashboard-screen";
  StammtischDashboardScreen({Key? key}) : super(key: key);
  List<Widget> appBarActions = [];

  @override
  State<StammtischDashboardScreen> createState() =>
      _StammtischDashboardScreenState();
}

class _StammtischDashboardScreenState extends State<StammtischDashboardScreen> {
  List<Widget> appBarActions = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final stammtischData = Provider.of<StammtischItemData>(context);
    return Center(
      child: Text(stammtischData.title),
    );
  }
}
