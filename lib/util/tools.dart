import 'package:countdown_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class Tools {
  static alertUser(BuildContext context, String s) {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          title: const Text('Oops!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(s),
              ],
            ),
          )
      );
    });
  }
  static IconData getIconData(String type) {
    switch(type) {
      case "Event":
        return Icons.event;
      case "Birthday":
        return Icons.cake;
      case "Party":
        return Icons.celebration;
      case "Exam":
        return Icons.edit_calendar_outlined;
      case "Lecture":
        return Icons.school;
      case "Flight":
        return Icons.flight;
      case "Bus":
        return Icons.bus_alert;
      case "Conference":
        return Icons.business_center_outlined;
      default:
        return Icons.event;
    }
  }

  static List<PickerItem> getRemainingTimeAsPickerList(Event e, String time) {
    List<PickerItem> res = <PickerItem>[];
    Duration d = e.endDate!.difference(DateTime.now());
    switch (time) {
      case "days":
        if (d.inDays > 0) {
          for (int i = 0; i < d.inDays; i++) {
            res.add(new PickerItem(text: Text((i+1).toString()), value: i+1));
          }
        }
        return res;
      case "hours":
        if (d.inHours > 0) {
          for (int i = 1; i < d.inHours; i++) {
            if (i >= 25) {
              break;
            }
            res.add(new PickerItem(text: Text((i).toString()), value: i));
          }
        }
        return res;
      case "minutes":
        if (d.inMinutes > 0) {
          res.add(new PickerItem(text: Text("1"), value: 1));
          for (int i = 5; i < d.inMinutes; i+=5) {
            if (i > 55) {
              break;
            }
            res.add(new PickerItem(text: Text((i).toString()), value: i));
          }
        }

        return res;
      default:
        return res;
    }
  }

  static Duration getDurationByTime(List<dynamic> time) {
    switch(time[0]) {
      case "day/s":
        return Duration(days: time[1]);
      case "hour/s":
        return Duration(hours: time[1]);
      case "minute/s":
        return Duration(minutes: time[1]);
      default:
        return Duration(seconds: 0);
    }
  }
}