import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import './widgets/reminder_card.dart';
import '../../models/reminder.dart';
import '../../helpers/arguments.dart';
import '../../providers/notification_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../providers/theme_provider.dart';

class ReminderScreen extends StatefulWidget {
  static const routeName = "/reminder";

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  @override
  Widget build(BuildContext context) {
    final Args args = ModalRoute.of(context).settings.arguments;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final reminderProvider = Provider.of<ReminderProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    DateTime selectedDateTime;
    // DateTime date;
    // DateTime time;

    // final timeZone = TimeZone();

    // void addReminder(DateTime dateTime) async {
    //   // The device's timezone.
    //   String timeZoneName = await timeZone.getTimeZoneName();

    //   // Find the 'current location'
    //   final location = await timeZone.getLocation(timeZoneName);

    //   final scheduledDate = tz.TZDateTime.from(dateTime, location);

    //   var androidPLatformChannelSpecifics = AndroidNotificationDetails(
    //     "alarm-notif",
    //     "alarm-notif",
    //     "Channel for Alarm Notification",
    //     icon: "@mipmap/justnotes_icon",
    //     largeIcon: DrawableResourceAndroidBitmap("@mipmap/justnotes_icon"),
    //   );

    //   var platformChannelSpecifics =
    //       NotificationDetails(android: androidPLatformChannelSpecifics);
    //   // key = int.parse(DateTime.now().toString());

    //   try {
    //     await flutterLocalNotificationsPlugin.zonedSchedule(
    //       0,
    //       "${args.title}",
    //       "${args.desc}",
    //       scheduledDate,
    //       platformChannelSpecifics,
    //       androidAllowWhileIdle: true,
    //       uiLocalNotificationDateInterpretation:
    //           UILocalNotificationDateInterpretation.absoluteTime,
    //     );
    //     Fluttertoast.showToast(
    //       msg: "Reminder added",
    //       fontSize: 16,
    //       gravity: ToastGravity.SNACKBAR,
    //       toastLength: Toast.LENGTH_SHORT,
    //     );
    //     // reminderProvider.setReminder(
    //     //   selectedDate: date,
    //     //   selectedTime: time,
    //     // );
    //   } catch (ex) {
    //     print("Date Time Exception:- $ex");
    //   }
    // }

    void customDateTime() async {
      print("Custom Date Time");
      await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(seconds: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      ).then(
        (selectedDate) async {
          final now = DateTime.now();
          if (selectedDate != null) {
            await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
            ).then((selectedTime) async {
              if (selectedTime != null) {
                selectedDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                print(
                    "Selected DateTime in Reminder Screen: $selectedDateTime");
                reminderProvider.saveReminder(
                  Reminder(
                    id: args.index,
                    title: args.title,
                    desc: args.desc,
                    date: selectedDate,
                    time: selectedTime,
                  ),
                  selectedDateTime,
                );
                await notificationProvider.setReminder(
                  Reminder(
                    id: args.index,
                    title: args.title,
                    desc: args.desc,
                    date: selectedDate,
                    time: selectedTime,
                  ),
                );
                Fluttertoast.showToast(
                  msg: "Reminder added",
                  fontSize: 16,
                  gravity: ToastGravity.SNACKBAR,
                  toastLength: Toast.LENGTH_SHORT,
                );
                print("Picked Date:- $selectedDate");
                print("Picked Time:- $selectedTime");
                // addReminder(selectedDateTime);
              } else {
                return;
              }
            });
          } else {
            return;
          }
        },
      );
    }

    void addPredefinedReminder(int minutes) async {
      final DateTime nowDateTime = DateTime.now();
      final TimeOfDay nowTime =
          TimeOfDay.fromDateTime(nowDateTime.add(Duration(minutes: minutes)));
      selectedDateTime = DateTime(
        nowDateTime.year,
        nowDateTime.month,
        nowDateTime.day,
        nowDateTime.hour,
        nowDateTime.minute + minutes,
        nowDateTime.second,
      );
      reminderProvider.saveReminder(
        Reminder(
          id: args.index,
          title: args.title,
          desc: args.desc,
          date: nowDateTime,
          time: nowTime,
        ),
        selectedDateTime,
      );
      await notificationProvider.setReminder(
        Reminder(
          id: args.index,
          title: args.title,
          desc: args.desc,
          date: nowDateTime,
          time: nowTime,
        ),
        predefinedInterval: ((minutes * 60) - nowDateTime.second),
      );
      Fluttertoast.showToast(
        msg: "Reminder added",
        fontSize: 16,
        gravity: ToastGravity.SNACKBAR,
        toastLength: Toast.LENGTH_SHORT,
      );
      print(
          "Predefined Interval in Reminder Screen: ${(minutes * 60) - nowDateTime.second}");
    }

    return Scaffold(
      backgroundColor:
          themeProvider.isDarkTheme ? Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Reminder",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: themeProvider.isDarkTheme
                ? Colors.white.withOpacity(0.9)
                : Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            splashRadius: 25,
            tooltip: "Remove Reminder",
            icon: Icon(
              Icons.delete,
              color: themeProvider.isDarkTheme
                  ? Color(0xFFf44336)
                  : Colors.red.shade700,
            ),
            onPressed: () async {
              return await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: themeProvider.isDarkTheme
                      ? Color(0xFF424242)
                      : Colors.white,
                  title: Text(
                    "Are you sure?",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,
                      color: themeProvider.isDarkTheme
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  content: Text(
                    "Delete the Reminder?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        primary: Colors.grey.shade300,
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => notificationProvider.deleteNotification(
                        context,
                        ReminderProvider.generateKeyId(args.title),
                        args.index,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: themeProvider.isDarkTheme
                            ? Color(0xFFf44336)
                            : Colors.red.shade700,
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        backgroundColor:
            themeProvider.isDarkTheme ? Color(0xFF121212) : Colors.white,
        brightness:
            themeProvider.isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      body: FutureBuilder(
        future: reminderProvider.getReminderById(args.index),
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child: snapshot.hasData
                    ? ReminderCard(
                        id: snapshot.data.id,
                        title: snapshot.data.title,
                        dateTime: snapshot.data.dateTimeString,
                        cardColor: themeProvider.isDarkTheme
                            ? Color(args.darkColor)
                            : Color(args.lightColor),
                      )
                    : null,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (ctx, index) {
                  String text;
                  Function onTapFunction;
                  if (index == 0) {
                    text = "Select custom date & time";
                    onTapFunction = customDateTime;
                  } else if (index == 1) {
                    text = "Remind me in 10 minutes";
                    onTapFunction = () => addPredefinedReminder(10);
                  } else if (index == 2) {
                    text = "Remind me in 15 minutes";
                    onTapFunction = () => addPredefinedReminder(15);
                  }
                  return Column(
                    children: <Widget>[
                      Card(
                        key: UniqueKey(),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        elevation: 0.0,
                        color: themeProvider.isDarkTheme
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 20,
                          ),
                          leading: Text(
                            text,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: themeProvider.isDarkTheme
                                  ? Colors.white.withOpacity(0.9)
                                  : Colors.black,
                            ),
                          ),
                          onTap: onTapFunction,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                },
              ),
              // reminder.isReminderSet ?? false
              // ? ReminderCard(
              //   date: reminderProvider.date,
              //   time: reminderProvider.time,
              //   cardColor: themeProvider.isDarkTheme
              //   ? Color(args.darkColor)
              //   : Color(args.lightColor),
              // )
              // : Container(),
            ],
          );
        },
      ),
    );
  }
}
