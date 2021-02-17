import "package:flutter/material.dart";
import 'package:notes_app/providers/theme_provider.dart';
import "package:provider/provider.dart";

import "../../../providers/note_provider.dart";

class AddNoteFloatingActionButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Consumer<ThemeProvider>(
          builder: (ctx, theme, child) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: theme.isDarkTheme
              ? Colors.white.withOpacity(0.2)
              : Colors.grey.shade200,
              elevation: 0,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                leading: Icon(
                  Icons.add_circle,
                  color: theme.isDarkTheme
                  ? Colors.white
                  : Colors.grey.shade900,
                  size: 30,
                ),
                title: Text(
                  "Add a note",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    color: theme.isDarkTheme
                    ? Colors.white
                    : Colors.black,
                  ),
                ),
                onTap: () => noteProvider.addNote(context: context),
              ),
            );
          }
        ),
      ],
    );
  }
}