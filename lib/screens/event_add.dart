import 'package:countdown_app/services/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:countdown_app/models/event.dart';

import '../data/dbHelper.dart';
import '../util/tools.dart';

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
  late final LocalNotificationService notificationService;

  String typeValue = "Event";
  var items = [
    'Event',
    'Birthday',
    'Exam',
    'Conference',
    'Party',
    'Lecture',
    'Flight',
    'Bus'
  ];

  var dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    notificationService = LocalNotificationService();
    notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Create New Event"),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              buildTypeField(),
              buildNameField(),
              buildDescriptionField(),
              buildEndDateText(),
              buildDateField(),
              buildTimeField(),
              buildSaveButton(),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  buildTypeField() {
    return Row(
      children: [
        Expanded(child:
          Text("Event Type: ")
        ),
        Expanded(child: DropdownButton(
          value: typeValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              typeValue = newValue!;
            });
          },
        ))
      ],
    );
  }

  buildNameField() {
    return TextField(
      decoration: InputDecoration(labelText: "Event Name"),
      controller: txtName,
      key: Key("Event Add Name Field")
    );
  }

  buildDescriptionField() {
    return TextField(
      decoration: InputDecoration(labelText: "Event Description"),
      controller: txtDescription,
      maxLines: 10,
      minLines: 5,
      key: Key("Event Add Description Field")
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
          initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
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
          if (!txtName.text.isNotEmpty) {
            Tools.alertUser(context, "Event name must be given.");
          }
          else if (endDate.compareTo(DateTime.now()) <= 0) {
            Tools.alertUser(context, "Event date must be a future date.");
          }
          else {
            addEvent();
          }
        },
        key: Key("Event Add Save Button"),
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
    int? id = await dbHelper.insert(Event(
        type: typeValue,
        name: txtName.text,
        description: txtDescription.text,
        endDate: this.endDate,
      )
    );

    int remainingTime = this.endDate.difference(DateTime.now()).inSeconds;
    await notificationService.showScheduledNotification(
        id: id!,
        title: 'Event Calendar',
        body: 'Your event ${txtName.text} is over!',
        seconds: remainingTime
    );

    Navigator.pop(context, true);
  }
}
