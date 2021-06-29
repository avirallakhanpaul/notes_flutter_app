import 'package:flutter/material.dart';

class Reminder {
  final String id;
  final String title;
  final String desc;
  final DateTime date;
  final TimeOfDay time;
  final String dateTimeString;

  Reminder({
    this.id,
    this.title,
    this.desc,
    this.date,
    this.time,
    this.dateTimeString,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "date": date,
        "time": time,
        "dateTimeString": dateTimeString,
      };

  Reminder toReminder(id, title, dateTime) => Reminder(
        id: id,
        title: title,
        date: date,
        time: time,
        dateTimeString: dateTime,
      );
}
