import 'package:countdown_app/data/dbHelper.dart';
import 'package:countdown_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EventDetail extends StatefulWidget {
  Event event;
  EventDetail(this.event);

  @override
  State<StatefulWidget> createState() {
    return _EventDetailState(event);
  }

}
enum Options {delete, update}

class _EventDetailState extends State {
  Event event;
  _EventDetailState(this.event);
  TextEditingController txtName = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  DateTime endDate = DateTime.now();
  TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
  var dbHelper = DbHelper();

  @override
  void initState() {
    txtName.text = event.name!;
    txtDescription.text = event.description!;
    endDate = event.endDate!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Detail: ${event.name}"),
        actions: [
          PopupMenuButton<Options>(
              onSelected: selectProcess,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                PopupMenuItem<Options>(
                  value: Options.delete,
                  child: Text("Delete"),
                ),
                PopupMenuItem<Options>(
                  value: Options.update,
                  child: Text("Update"),
                )
              ]
          )
        ],
      ),
      body: buildEventDetail(),
    );
  }

  buildEventDetail() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: [
          buildNameField(),
          buildDescriptionField(),
          buildDateField(),
          buildTimeField(),
        ],
      ),
    );
  }

  void selectProcess(Options value) async{
    switch(value) {
      case Options.delete:
        await dbHelper.delete(event.id!);
        Navigator.pop(context, true);
        break;
      case Options.update:
        await dbHelper.update(Event.withId(
            id: event.id!,
            name: txtName.text,
            description: txtDescription.text,
            endDate: endDate
        ));
        Navigator.pop(context, true);
        break;
      default:
    }
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
}

