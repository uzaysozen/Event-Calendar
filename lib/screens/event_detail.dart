import 'package:countdown_app/data/dbHelper.dart';
import 'package:countdown_app/models/event.dart';
import 'package:flutter/material.dart';

import '../services/local_notification_service.dart';
import '../util/tools.dart';

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

  late final LocalNotificationService notificationService;

  @override
  void initState() {
    txtName.text = event.name!;
    txtDescription.text = event.description!;
    endDate = event.endDate!;
    notificationService = LocalNotificationService();
    notificationService.initialize();
    typeValue = event.type!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Event Detail: ${event.name}"),
      ),
      body: SingleChildScrollView(child: buildEventDetail(), reverse: true,),
    );
  }

  buildEventDetail() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: [
          buildTypeField(),
          buildNameField(),
          buildDescriptionField(),
          buildEndDateText(),
          buildDateField(),
          buildTimeField(),
          buildButtons(),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
            ),
          )
        ],
      ),
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
          initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
        ))!;
        endDate = DateTime(endDate.year, endDate.month, endDate.day,
            time.hour, time.minute, endDate.second, endDate.millisecond,
            endDate.microsecond);
        print(endDate);},
        child: Text('Choose a Time For the Event',)
    );
  }

  buildButtons() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: ElevatedButton(
                onPressed: () async {
                  await dbHelper.delete(event.id!);
                  await notificationService.cancelNotifications(event.id!);
                  Navigator.pop(context, true);
                },
                style: ElevatedButton.styleFrom(primary: Colors.red,),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: "Delete ",
                          style: TextStyle(fontSize: 16)
                      ),
                      WidgetSpan(
                        child: Icon(Icons.delete, size: 16),
                      ),
                    ],
                  ),
                )
            ),
          ),
        ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                onPressed: () async {
                  if (!txtName.text.isNotEmpty) {
                    Tools.alertUser(context, "Event name must be given.");
                  } else if (endDate.compareTo(DateTime.now()) <= 0) {
                    Tools.alertUser(context, "Event date must be a future date.");
                  }
                  else {
                    await dbHelper.update(Event.withId(
                      id: event.id!,
                      type: typeValue,
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
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Update ",
                        style: TextStyle(fontSize: 16)
                      ),
                      WidgetSpan(
                        child: Icon(Icons.update, size: 16),
                      ),
                    ],
                  ),
                )
            ),
          )
        )
      ],
    );
  }
}

