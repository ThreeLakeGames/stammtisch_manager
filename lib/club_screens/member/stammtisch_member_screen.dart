import 'package:flutter/material.dart';

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
    return const Center(
      child: Text(
        "Member Screen",
      ),
    );
  }
}
