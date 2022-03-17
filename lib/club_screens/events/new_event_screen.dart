import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stammtisch_manager/club_screens/events/event_model.dart';
import 'package:stammtisch_manager/provider/stammtisch_item_data.dart';

class NewEventScreen extends StatefulWidget {
  static const routeName = "/new-event-screen";
  final EventModel eventData;
  final bool isEditing;
  const NewEventScreen(
      {Key? key, required this.eventData, required this.isEditing})
      : super(key: key);

  factory NewEventScreen.addEvent() {
    return NewEventScreen(
      eventData: EventModel.createNew(),
      isEditing: false,
    );
  }
  factory NewEventScreen.editEvent(EventModel eventModel) {
    return NewEventScreen(
      eventData: eventModel,
      isEditing: true,
    );
  }

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _form = GlobalKey<FormState>();
  late EventModel eventData;
  late bool isEditing;

  @override
  void initState() {
    eventData = widget.eventData;
    isEditing = widget.isEditing;
    super.initState();
  }

  void _submitData() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    Navigator.of(context).pop(eventData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? "Termin bearbeiten" : "Termin hinzufügen",
        ),
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
                _buildTitleField(),
                const SizedBox(
                  height: 10,
                ),
                _buildLocationField(),
                _buildDescriptionField(),
                const SizedBox(
                  height: 20,
                ),
                ..._buildDateField(),
                const SizedBox(
                  height: 10,
                ),
                ..._buildTimeField(),
                const SizedBox(
                  height: 20,
                ),
                if (!isEditing) ..._buildRepeatingOption(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: () {}, child: const Text("Abbrechen")),
                    ElevatedButton(
                        onPressed: () {
                          _submitData();
                        },
                        child: Text(
                          isEditing
                              ? "Termin bearbeiten"
                              : eventData.repeatEvent == RepeatEvent.noRepeat ||
                                      eventData.repeatingCount == 1
                                  ? "neuen Termin hinzufügen"
                                  : "${eventData.repeatingCount} Termine hinzufügen",
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTitleField() {
    return TextFormField(
      initialValue: eventData.title,
      decoration: const InputDecoration(
          labelText: "Anlass", hintText: "z.B. Stammtisch-Termin"),
      onSaved: (newTitle) {
        eventData.title = newTitle ?? "";
      },
      validator: (newTitle) {
        if (newTitle!.isEmpty) {
          return "Bitte geben Sie einen Anlass an!";
        }
        return null;
      },
    );
  }

  TextFormField _buildLocationField() {
    return TextFormField(
      initialValue: eventData.location,
      decoration:
          const InputDecoration(labelText: "Ort", hintText: "z.B. Kellerwirt"),
      onSaved: (location) {
        eventData.location = location ?? "";
      },
    );
  }

  TextFormField _buildDescriptionField() {
    return TextFormField(
      initialValue: eventData.description,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
          labelText: "Beschreibung",
          hintText: "z.B. Besprechung Stammtischausflug!"),
      onSaved: (newDescription) {
        eventData.description = newDescription ?? "";
      },
    );
  }

  List<Widget> _buildRepeatingOption() {
    return [
      const Text("Wiederholung"),
      DropdownButtonFormField<RepeatEvent>(
          value: RepeatEvent.noRepeat,
          items: repeatingOptions,
          onChanged: (newRepeatEvent) {
            setState(() {
              eventData.repeatEvent = newRepeatEvent ?? RepeatEvent.noRepeat;
            });
          }),
      if (eventData.repeatEvent != RepeatEvent.noRepeat) ...[
        const SizedBox(
          height: 20,
        ),
        const Text("Anzahl Termine"),
        DropdownButtonFormField<int>(
          value: eventData.repeatingCount,
          items: List<DropdownMenuItem<int>>.generate(
              10,
              (index) => DropdownMenuItem<int>(
                    child: Text("${index + 1}",
                        style: Theme.of(context).textTheme.bodyMedium),
                    value: index + 1,
                  )),
          onChanged: (newRepeatCount) {
            setState(() {
              eventData.repeatingCount = newRepeatCount ?? 1;
            });
          },
        ),
      ],
      const SizedBox(
        height: 30,
      )
    ];
  }

  List<Widget> _buildDateField() {
    return [
      const Text("Datum"),
      const SizedBox(
        height: 4,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.yMMMd().format(eventData.date),
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
    ];
  }

  List<Widget> _buildTimeField() {
    return [
      const Text("Uhrzeit"),
      const SizedBox(
        height: 4,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat.Hm().format(eventData.date),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          OutlinedButton(
            onPressed: startTimePicker,
            child: Row(
              children: const [
                Icon(Icons.alarm),
                Text(
                  "   Uhrzeit auswählen",
                ),
              ],
            ),
          )
        ],
      )
    ];
  }

  void startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: eventData.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        eventData.date = value;
      });
    });
  }

  void startDateTimePicker() {
    DatePicker.showDatePicker(
      context,
      currentTime: eventData.date,
      minTime: DateTime.now().subtract(const Duration(days: 365)),
      maxTime: DateTime.now().add(const Duration(days: 365 * 3)),
      locale: LocaleType.de,
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        eventData.date = DateTime(
          value.year,
          value.month,
          value.day,
          eventData.date.hour,
          eventData.date.minute,
        );
      });
    });
  }

  void startTimePicker() {
    DatePicker.showTimePicker(context,
            showSecondsColumn: false,
            currentTime: eventData.date,
            locale: LocaleType.de)
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        eventData.date = value;
      });
    });
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
