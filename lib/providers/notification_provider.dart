import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import "package:flutter/material.dart";
import 'package:notes_app/providers/reminder_provider.dart';

import '../models/reminder.dart';

class NotificationProvider extends ChangeNotifier {
  Future<void> setReminder(Reminder reminder,
      {int predefinedInterval = 0}) async {
    final String timeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    int intervalTime;

    if (predefinedInterval == 0) {
      // final scheduledDate = reminder.date;
      final scheduledTime = reminder.time;
      final nowTime = TimeOfDay.now();
      final nowDate = DateTime.now();
      print("Now DateTime from Notif. Provider: $nowDate");

      // Seconds in 1 Day = 86400
      // Seconds in 1 Hour = 3600
      // Seconds in 1 Minute = 60

      // Minutes in 1 Day = 1440
      // Minutes in 1 Hour = 60

      final intervalTime =
          ((scheduledTime.hour * 3600) + (scheduledTime.minute * 60)) -
              ((nowTime.hour * 3600) + (nowTime.minute * 60)) -
              nowDate.second;

      print("Selected Time: $scheduledTime");
      print("Interval Time: $intervalTime");

      if (intervalTime < 0) {
        print("Error creating notification. Please try again");
        return;
      }
    } else {
      intervalTime = predefinedInterval;
    }

    print("Interval Time in Notif. Provider: $intervalTime");

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "JustNotes_Channel_1",
        title: reminder.title,
        body: reminder.desc,
      ),
      schedule: NotificationInterval(
        timeZone: timeZone,
        interval: intervalTime,
      ),
    );

    Timer timer = Timer(Duration(seconds: intervalTime), () async {
      await ReminderProvider().clearReminderById(reminder.id);
    });
  }
}
