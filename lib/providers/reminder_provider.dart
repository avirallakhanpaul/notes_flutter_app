import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import '../helpers/db_helper.dart';
import '../models/reminder.dart';

class ReminderProvider with ChangeNotifier {
  ReminderProvider() {
    loadFromDb();
  }

  String tableName = "reminder_table";

  bool _isReminderSet;
  bool get isReminderSet => _isReminderSet;

  DateTime _dateTime;
  DateTime get dateTime => _dateTime;

  // final dateFormat = DateFormat("EEEE, d'th' MMMM y").add_jm();
  final dateFormat = DateFormat("yyyy-MM-dd kk:mm:ss");
  // DateTime _time;
  // DateTime get time => _time;

  // Future<void> _initPath() async {
  //   if (file == null) {
  //     try {
  //       final directory = await getApplicationDocumentsDirectory();
  //       file = File('${directory.path}/reminders.txt');
  //     } catch (error) {
  //       print("File Exception:- $error");
  //     }
  //   } else {
  //     return;
  //   }
  // }

  // Future<dynamic> loadFromFile() async {
  //   await _initPath();
  //   try {
  //     String dateTimeString = await file.readAsString();
  //     if (dateTimeString != null || dateTimeString != "") {
  //       print("Reminder in File $dateTimeString");
  //       _dateTime = dateFormat.parse(dateTimeString);
  //       print("Parsed Reminder in Provider:- $dateTimeString");
  //       return _dateTime;
  //     } else {
  //       print("File is empty");
  //       return null;
  //     }
  //   } catch (error) {
  //     print("Load File Exception:- $error");
  //   }
  // }

  Future<dynamic> loadFromDb() async {
    final reminderData = await DBHelper.getData(tableName);

    if (reminderData.isNotEmpty) {
      for (int i = 0; i < reminderData.length; i++) {
        print("Reminder DB Data: ${reminderData[i]["reminderTitle"]}");
      }
    } else {
      return;
    }
  }

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

  // Future<void> _saveToFile() async {
  //   await _initPath();
  //   // final dateTime = DateTime(
  //   // final dateTimeText = _dateTime.toString();
  //   await file.writeAsString(dateFormat.format(_dateTime).toString());
  //   print('saved');
  // }

  Future<Reminder> getReminderById(String id) async {
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
}
