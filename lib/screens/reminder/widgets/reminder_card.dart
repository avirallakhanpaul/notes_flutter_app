import "package:flutter/material.dart";
import 'package:intl/intl.dart';
// import 'package:notes_app/providers/reminder_provider.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ReminderCard extends StatefulWidget {

  final DateTime date;
  final DateTime time;
  final Color cardColor;

  ReminderCard({
    @required this.date,
    @required this.time,
    @required this.cardColor,
  });

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {

  final dateFormat = DateFormat("EEEE, dMMMMy");
  final timeFormat = DateFormat("jm");

  @override
  Widget build(BuildContext context) {

    print(widget.date);
    print(widget.time);

    final themeProvider = Provider.of<ThemeProvider>(context);

    final formattedDate = dateFormat.format(widget.date);
    final formattedTime = timeFormat.format(widget.time);

    print(formattedDate);
    print(formattedTime);

    return Card(
      color: widget.cardColor,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.notifications_outlined,
              size: 40,
              color: Colors.white,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  formattedDate.toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  formattedTime.toString(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}