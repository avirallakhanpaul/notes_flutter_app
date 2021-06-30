import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import '../helpers/db_helper.dart';
import '../models/reminder.dart';

class ReminderProvider with ChangeNotifier {
  ReminderProvider() {
    // loadFromDb();
  }

  String tableName = "reminder_table";

  bool _isReminderSet;
  bool get isReminderSet => _isReminderSet;

  DateTime _dateTime;
  DateTime get dateTime => _dateTime;

  final dateFormat = DateFormat("yyyy-MM-dd kk:mm:ss");

  // Future<dynamic> loadFromDb() async {
  // final reminderData = await DBHelper.getData(tableName);
  // final dateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
  // final nowDateTime = DateTime.now();

  // To clear out any reminders which were not deleted by the timer
  // for (int i = 0; i < reminderData.length; i++) {
  //   print("Reminder Object: ${reminderData[i]}");
  //   DateTime reminderDateTime =
  //       dateFormat.parse(reminderData[i]["dateTimeString"]);
  //   print("Reminder Date Time in Reminder Provider: $reminderDateTime");
  //   if (nowDateTime.isAfter(reminderDateTime)) {
  //     clearReminderById(reminderData[i]["id"]);
  //   }
  // }

  // if (reminderData.isNotEmpty) {
  //   for (int i = 0; i < reminderData.length; i++) {
  //     print("Reminder DB Data: ${reminderData[i]["reminderTitle"]}");
  //   }
  // } else {
  //   return;
  // }
  // }

  void saveReminder(Reminder reminder, selectedDateTime) async {
    _dateTime = selectedDateTime;
    await DBHelper.insertToDb(
      tableName,
      {
        "id": reminder.id,
        "title": reminder.title,
        "dateTimeString": dateTime.toString(),
      },
    );
    print("Reminder ${reminder.id} saved to DB");
    notifyListeners();
  }

  Future<void> clearRedundantReminders() async {
    final reminderData = await DBHelper.getData(tableName);
    final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    // final dateFormat = DateFormat.yMMMd("en_US");
    final nowDateTime = DateTime.now();

    print("clearRedundantReminders Function called");

    // To clear out any reminders which were not deleted by the timer
    for (int i = 0; i < reminderData.length; i++) {
      print("Reminder Object: ${reminderData[i]}");
      DateTime reminderDateTime =
          dateFormat.parse(reminderData[i]["dateTimeString"]);
      print("Reminder Date Time in Reminder Provider: $reminderDateTime");
      if (nowDateTime.isAfter(reminderDateTime)) {
        print("Reminder CLEARED!");
        clearReminderById(reminderData[i]["id"]);
      }
    }
  }

  Future<Reminder> getReminderById(String id) async {
    await clearRedundantReminders();
    final mapData = await DBHelper.getData(tableName, arg: id);
    print("Reminder ${mapData[0]["id"]} data from DB: ${mapData[0]}");
    return Reminder().toReminder(
      mapData[0]["id"],
      mapData[0]["title"],
      mapData[0]["dateTimeString"],
    );
  }

  Future<void> clearReminderById(String id) async {
    await DBHelper.deleteReminderFromDb(tableName, id);
    notifyListeners();
  }

  static int generateKeyId(String title) {
    int keyId;
    var sum = 0;
    final titleCodeUnits = title.codeUnits;

    for (int i = 0; i < titleCodeUnits.length; i++) {
      sum += titleCodeUnits[i];
    }

    print("KeyId in Reminder Provider: $sum");
    keyId = sum;
    return keyId;
  }
}
