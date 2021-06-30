import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/reminder_provider.dart';

class ReminderCard extends StatefulWidget {
  final String id;
  final String title;
  final String dateTime;
  final Color cardColor;

  ReminderCard({
    @required this.id,
    this.title,
    @required this.dateTime,
    @required this.cardColor,
  });

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  final dateFormat = DateFormat("EEEE, d'th' MMMM y").add_jm();
  final stringConvertToDateFormat = DateFormat("yyyy-MM-dd hh:mm:ss");

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
            return Padding(
              padding: const EdgeInsets.only(
                top: 0,
                bottom: 40.0,
                left: 10,
                right: 10,
              ),
              child: Card(
                color: widget.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.notifications_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: Text(
                          formattedDate,
                          // "No Reminder",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.66,
                            height: 1.3,
                            // height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
