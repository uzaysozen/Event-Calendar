import 'package:flutter/material.dart';

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
}