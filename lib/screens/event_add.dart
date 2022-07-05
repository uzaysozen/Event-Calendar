import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:countdown_app/models/event.dart';

import '../data/dbHelper.dart';

class EventAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EventAddState();
  }
}

class EventAddState extends State {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  DateTime endDate = DateTime.now();
  TimeOfDay time = TimeOfDay(hour: 0, minute: 0);

  var dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Add New Event"),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            buildNameField(),
            buildDescriptionField(),
            buildEndDateText(),
            buildDateField(),
            buildTimeField(),
            buildSaveButton(),
          ],
        ),
      ),
    );
  }

  buildNameField() {
    return TextField(
      decoration: InputDecoration(labelText: "Event Name"),
      controller: txtName,
    );
  }

  buildDescriptionField() {
    return TextField(
      decoration: InputDecoration(labelText: "Event Description"),
      controller: txtDescription,
      maxLines: 10,
      minLines: 5,
    );
  }

  buildDateField() {
    return TextButton(
        onPressed: () async { endDate = (await showDatePicker(
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2099),
          context: context,
        ))!;
          setState(() {
            buildEndDateText();
          });
        },
        child: Text('Choose a Date For the Event',)
    );
  }

  buildTimeField() {
    return TextButton(
        onPressed: () async { time = (await showTimePicker(
          initialEntryMode: TimePickerEntryMode.dial,
          context: context,
          initialTime: TimeOfDay(hour: endDate.hour, minute: endDate.minute),
        ))!;
        endDate = DateTime(endDate.year, endDate.month, endDate.day,
            time.hour, time.minute, endDate.second, endDate.millisecond,
            endDate.microsecond);
        setState(() {
          buildEndDateText();
        });
        },
        child: Text('Choose a Time For the Event',)
    );
  }

  buildSaveButton() {
    return ElevatedButton(
        onPressed: (){
          if (txtName.text.isNotEmpty) {
            addEvent();
          }
          else {
            showDialog(context: context, builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text('Oops!'),
                  content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text('Event name must be given.'),
                    ],
                  ),
                )
              );
            });
          }
        },
        child: Text("Create Event")
    );
  }

  buildEndDateText() {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(text: "Event Date: ", style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text:
                  "${endDate.day < 10 ? '0' + endDate.day.toString() : endDate.day}/"
                  "${endDate.month < 10 ? '0' + endDate.month.toString() : endDate.month}/"
                  "${endDate.year} on "
                  "${endDate.hour < 10 ? '0' + endDate.hour.toString() : endDate.hour}"
                  ":${endDate.minute < 10 ? '0' + endDate.minute.toString() : endDate.minute}"
              ),
            ],
          ),
        )
    );
  }

  void addEvent() async{
    await dbHelper.insert(Event(
        name: txtName.text,
        description: txtDescription.text,
        endDate: this.endDate,
    )
    );

    Navigator.pop(context, true);
  }
}
