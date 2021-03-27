import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

class ReminderProvider with ChangeNotifier {

  ReminderProvider() {
    _loadFromPrefs();
  }

  SharedPreferences _prefs;
  String key = "reminder";

  bool _isReminderSet;
  bool get isReminderSet => _isReminderSet;

  DateTime _date;
  DateTime get date => _date;
  DateTime _time;
  DateTime get time => _time;

  Future<void> _initPrefs() async {
    if(_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    } else {
      return;
    }
  }

  void _loadFromPrefs() async {
    await _initPrefs();
    _isReminderSet = _prefs.getBool(key) ?? false;
    print("Is there any reminder:- $_isReminderSet");
    notifyListeners();
  }

  void setReminder({@required DateTime selectedDate, @required DateTime selectedTime}) async {
    await _initPrefs();
    _prefs.setBool(key, true);
    _loadFromPrefs();
    _date = selectedDate;
    _time = selectedTime;
    print("key set to TRUE");
    notifyListeners();
  }

  void clearReminders() async {
    await _initPrefs();
    _prefs.setBool(key, false);
    _loadFromPrefs();
    print("key set to false");
    notifyListeners();
  }
}