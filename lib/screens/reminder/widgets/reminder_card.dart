import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/reminder_provider.dart';

class ReminderCard extends StatefulWidget {
  final String id;
  final String dateTime;
  final Color cardColor;

  ReminderCard({
    @required this.id,
    @required this.dateTime,
    @required this.cardColor,
  });

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  final dateFormat = DateFormat("EEEE, d'th' MMMM y").add_jm();
  final stringConvertToDateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");

  // final timeFormat = DateFormat("jm");

  @override
  Widget build(BuildContext context) {
    final reminderProvider = Provider.of<ReminderProvider>(context);
    final DateTime stringParsedDateTime =
        stringConvertToDateFormat.parse(widget.dateTime);
    print("DateTime in Reminder Card:- ${widget.dateTime}");
    // print("Note ID in Reminder Card: ${widget.id}");

    // final themeProvider = Provider.of<ThemeProvider>(context);

    final formattedDate = dateFormat.format(stringParsedDateTime);
    // final formattedTime = timeFormat.format(widget.time);
    print("Formatted DateTime in Reminder Card:- $formattedDate");

    // print(formattedDate);
    // print(formattedTime);
    return FutureBuilder(
        future: reminderProvider.getReminderById(widget.id),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Card(
              color: widget.cardColor,
              margin: const EdgeInsets.only(
                top: 0,
                left: 10,
                right: 10,
                bottom: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.notifications_outlined,
                      size: 45,
                      color: Colors.white,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            formattedDate,
                            // "No Reminder",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.66,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // Text(
                          //   formattedTime.toString(),
                          //   style: TextStyle(
                          //     fontFamily: "Poppins",
                          //     fontSize: 22,
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.w700,
                          //     letterSpacing: 0.66,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
