import 'package:countdown_app/data/dbHelper.dart';
import 'package:countdown_app/models/event.dart';
import 'package:flutter/material.dart';

import '../services/local_notification_service.dart';

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

  String dropdownValue = 'second/s';
  var items = [
    'week/s',
    'day/s',
    'hour/s',
    'minute/s',
    'second/s',
  ];

  late final LocalNotificationService notificationService;

  @override
  void initState() {
    txtName.text = event.name!;
    txtDescription.text = event.description!;
    endDate = event.endDate!;
    notificationService = LocalNotificationService();
    notificationService.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Event Detail: ${event.name}"),
        actions: [
          PopupMenuButton<Options>(
              onSelected: selectProcess,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                PopupMenuItem<Options>(
                  value: Options.delete,
                  child: ListTile(
                    trailing: Icon(Icons.delete, color: Colors.red,), // your icon
                    title: Text("Delete", style: TextStyle(color: Colors.red),),
                  ),
                ),
                PopupMenuItem<Options>(
                  value: Options.update,
                  child: ListTile(
                    trailing: Icon(Icons.update, color: Colors.green,), // your icon
                    title: Text("Update", style: TextStyle(color: Colors.green),),
                  ),
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
          buildEndDateText(),
          buildDateField(),
          buildTimeField(),
          buildNotifyField()
        ],
      ),
    );
  }

  void selectProcess(Options value) async{
    switch(value) {
      case Options.delete:
        await dbHelper.delete(event.id!);
        await notificationService.cancelNotifications(event.id!);
        Navigator.pop(context, true);
        break;
      case Options.update:
        if (txtName.text.isNotEmpty) {
          await dbHelper.update(Event.withId(
              id: event.id!,
              name: txtName.text,
              description: txtDescription.text,
              endDate: endDate,
          ));
          int remainingTime = this.endDate.difference(DateTime.now()).inSeconds;
          await notificationService.showScheduledNotification(
              id: event.id!,
              title: 'Event Calendar',
              body: 'Your event ${txtName.text} is over!',
              seconds: remainingTime
          );
          Navigator.pop(context, true);
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
        break;
      default:
    }
  }

  buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Event Name"),
      controller: txtName,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      }
    );
  }

  buildDescriptionField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Event Description"),
      controller: txtDescription,
      maxLines: 10,
      minLines: 5,
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

  buildNotifyField() {
    return Row(
      children: [
        Expanded(child: TextField(
            decoration: InputDecoration(labelText: "Notify me"),
            keyboardType: TextInputType.number
        ),),
        Expanded(child: DropdownButton(
          value: dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
        ))
      ],
    );
  }
}

