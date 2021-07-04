import "package:flutter/material.dart";
import 'package:notes_app/providers/theme_provider.dart';
import "package:provider/provider.dart";

import '../../../providers/note_provider.dart';

class CustomFloatingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);

    return Consumer<ThemeProvider>(
      builder: (ctx, theme, child) {
        return RawMaterialButton(
          fillColor: theme.isDarkTheme ? Color(0xFF64B5F6) : Color(0xFF2196F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 10,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          enableFeedback: true,
          splashColor:
              theme.isDarkTheme ? Colors.blue.shade600 : Colors.blue.shade300,
          onPressed: () => noteProvider.addNote(context: context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.add,
                color: theme.isDarkTheme ? Color(0xFF121212) : Colors.white,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Add note",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.isDarkTheme ? Color(0xFF121212) : Colors.white,
                ),
              ),
              SizedBox(
                width: 2,
              ),
            ],
          ),
        );
        // return Card(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   color: theme.isDarkTheme
        //       ? Colors.white.withOpacity(0.2)
        //       : Colors.grey.shade200,
        //   elevation: 0,
        //   child: ListTile(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     leading: Icon(
        //       Icons.add_circle,
        //       color: theme.isDarkTheme ? Colors.white : Colors.grey.shade900,
        //       size: 30,
        //     ),
        //     title: Text(
        //       "Add a note",
        //       style: TextStyle(
        //         fontSize: 18,
        //         fontFamily: "Poppins",
        //         color: theme.isDarkTheme ? Colors.white : Colors.black,
        //       ),
        //     ),
        //     onTap: () => noteProvider.addNote(context: context),
        //   ),
        // );
      },
    );
  }
}
