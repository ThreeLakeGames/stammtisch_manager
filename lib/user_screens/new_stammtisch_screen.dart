import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class NewStammtischScreen extends StatefulWidget {
  static const routeName = "/new-stammtisch-screen";
  const NewStammtischScreen({Key? key}) : super(key: key);

  @override
  State<NewStammtischScreen> createState() => _NewStammtischScreenState();
}

class _NewStammtischScreenState extends State<NewStammtischScreen> {
  final _formKey = GlobalKey<FormState>();
  StammtischItemData newStammtisch = StammtischItemData(id: "", title: "");
  void _submitData() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    addStammtischToDB();
    Navigator.of(context).pop();
  }

  Future<void> addStammtischToDB() async {
    try {
      await FirebaseFirestore.instance
          .collection("stammtischList")
          .add({"stammtischTitle": newStammtisch.title}).then(
              (value) => newStammtisch.id = value.id);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neuen Stammtisch erstellen"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFormField(
                decoration:
                    const InputDecoration(labelText: "Stammtisch Titel"),
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Bitte einen gültigen Titel eingeben";
                  }
                },
                onSaved: (title) {
                  newStammtisch.title = title ?? "";
                }),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text("Neuen Stammtisch erstellen"),
            )
          ],
        ),
      ),
    );
  }
}
