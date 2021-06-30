import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import "package:flutter/material.dart";
import 'package:notes_app/providers/reminder_provider.dart';

import '../models/reminder.dart';

class NotificationProvider extends ChangeNotifier {
  Future<void> checkPermission() async {
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      } else {
        return;
      }
    });
  }

  Future<void> setReminder(Reminder reminder,
      {int predefinedInterval = 0}) async {
    await checkPermission();
    final String timeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    int intervalTime;

    if (predefinedInterval == 0) {
      final scheduledTime = reminder.time;
      final nowTime = TimeOfDay.now();
      final nowDate = DateTime.now();
      print("Now DateTime from Notif. Provider: $nowDate");

      // Seconds in 1 Day = 86400
      // Seconds in 1 Hour = 3600
      // Seconds in 1 Minute = 60

      // Minutes in 1 Day = 1440
      // Minutes in 1 Hour = 60

      intervalTime =
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
        id: ReminderProvider.generateKeyId(reminder.title),
        channelKey: "JustNotes_Channel_1",
        title: reminder.title,
        body: reminder.desc,
      ),
      schedule: NotificationInterval(
        timeZone: timeZone,
        interval: intervalTime,
      ),
    );

    // ignore: unused_local_variable
    Timer timer = Timer(Duration(seconds: intervalTime), () async {
      await ReminderProvider().clearReminderById(reminder.id);
      notifyListeners();
    });
  }

  void deleteNotification(BuildContext context, int keyId, String id) async {
    AwesomeNotifications().cancel(keyId);
    await ReminderProvider().clearReminderById(id);
    Navigator.pop(context);
    notifyListeners();
  }
}
