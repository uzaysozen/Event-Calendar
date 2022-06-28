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
  DateTime? endDate;
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
            buildEndDateField(),
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

  buildEndDateField() {
    return TextButton(
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2099, 1, 1),
          onChanged: (date) {print('change $date');},
          onConfirm: (date) {this.endDate = date;},
          currentTime: DateTime.now(), locale: LocaleType.en);},
        child: Text('Choose a Date For the Event',)
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
