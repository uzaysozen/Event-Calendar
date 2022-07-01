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
        title: Text("Add New Event"),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: [
            buildNameField(),
            buildDescriptionField(),
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
        print(endDate);},
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
        print(endDate);},
        child: Text('Choose a Time For the Event',)
    );
  }

  buildSaveButton() {
    return ElevatedButton(
        onPressed: (){
          addEvent();
        },
        child: Text("Create Event")
    );
  }

  void addEvent() async{
    print(this.endDate);
    await dbHelper.insert(Event(
        name: txtName.text,
        description: txtDescription.text,
        endDate: this.endDate)
    );
    Navigator.pop(context, true);
  }
}
