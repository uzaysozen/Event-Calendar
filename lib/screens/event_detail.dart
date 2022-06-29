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
  var dbHelper = DbHelper();

  @override
  void initState() {
    txtName.text = event.name!;
    txtDescription.text = event.description!;
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
          buildEndDateField(),
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

  buildEndDateField() {
    return TextButton(
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2099, 1, 1),
              onChanged: (date) {print('change $date');},
              onConfirm: (date) {endDate = date;},
              currentTime: event.endDate, locale: LocaleType.en);},
        child: Text('Choose a Date For the Event',)
    );
  }
}

