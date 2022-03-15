import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class NewEventScreen extends StatefulWidget {
  static const routeName = "/new-event-screen";
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _form = GlobalKey<FormState>();
  EventModel newEvent = EventModel.createNew();

  void startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: newEvent.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        newEvent.date = value;
      });
    });
  }

  void startDateTimePicker() {
    DatePicker.showDatePicker(context,
            currentTime: newEvent.date,
            minTime: DateTime.now().subtract(const Duration(days: 365)),
            maxTime: DateTime.now().add(const Duration(days: 365 * 3)),
            locale: LocaleType.de)
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        newEvent.date = value;
      });
    });
  }

  void _submitData() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    Navigator.of(context).pop(newEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Termin hinzufügen"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Anlass", hintText: "z.B. Stammtisch-Termin"),
                  onSaved: (newTitle) {
                    newEvent.title = newTitle ?? "";
                  },
                  validator: (newTitle) {
                    if (newTitle!.isEmpty) {
                      return "Bitte geben Sie einen Anlass an!";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Ort", hintText: "z.B. Kellerwirt"),
                  onSaved: (location) {
                    newEvent.location = location ?? "";
                  },
                ),
                TextFormField(
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                      labelText: "Beschreibung",
                      hintText: "z.B. Besprechung Stammtischausflug!"),
                  onSaved: (newDescription) {
                    newEvent.description = newDescription ?? "";
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Datum"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(newEvent.date),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    OutlinedButton(
                      onPressed: startDateTimePicker,
                      child: Row(
                        children: const [
                          Icon(Icons.calendar_month),
                          Text(
                            "   Datum auswählen",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Wiederholung"),
                DropdownButtonFormField<RepeatEvent>(
                    value: RepeatEvent.noRepeat,
                    items: repeatingOptions,
                    onChanged: (newRepeatEvent) {
                      newEvent.repeatEvent =
                          newRepeatEvent ?? RepeatEvent.noRepeat;
                    }),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: () {}, child: const Text("Abbrechen")),
                    ElevatedButton(
                        onPressed: () {
                          _submitData();
                        },
                        child: const Text("neuen Termin hinzufügen")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<RepeatEvent>> get repeatingOptions {
    List<DropdownMenuItem<RepeatEvent>> items = [];
    for (final repeatEvent in RepeatEvent.values) {
      items.add(
        DropdownMenuItem(
          child: Text(repeatEvent.title,
              style: Theme.of(context).textTheme.bodyMedium),
          value: repeatEvent,
        ),
      );
    }
    return items;
  }
}
