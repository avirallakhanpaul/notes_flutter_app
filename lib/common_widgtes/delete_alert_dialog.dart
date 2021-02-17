import "package:flutter/material.dart";
import 'package:notes_app/providers/theme_provider.dart';
import "package:provider/provider.dart";

import "../providers/note_provider.dart";

class DeleteAlertDialog extends StatelessWidget {

  final String noteIndex;
  final bool fromNoteScreen;

  DeleteAlertDialog({this.noteIndex, this.fromNoteScreen});

  @override
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);

    return Consumer<ThemeProvider>(
      builder: (ctx, theme, child) {
        return AlertDialog(
          backgroundColor: theme.isDarkTheme
          ? Color(0xFF424242)
          : Colors.white,
          title: Text(
            "Delete?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              color: theme.isDarkTheme
              ? Colors.white 
              : Colors.black,
            ),
          ),
          content: Text(
            "Remove ${noteProvider.items[int.parse(noteIndex)].title} permanently?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              color: theme.isDarkTheme
              ? Colors.white 
              : Colors.black,
            ),
          ),
          actions: [
            RaisedButton(
              onPressed: () async => {
                if(fromNoteScreen) {
                  Navigator.of(context).pop(),

                  await noteProvider.deleteNote(
                    tableName: "user_notes",
                    id: noteProvider.items[int.parse(noteIndex)].id,
                  ),

                  Navigator.of(context).pop(),
                } else {
                  Navigator.of(context).pop(true),
                }
              },
              color: theme.isDarkTheme
              ? Color(0xFFf44336)
              : Colors.red.shade700,
              child: Text(
                "Delete",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              splashColor: Colors.grey.shade300,
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                  color: theme.isDarkTheme
                  ? Colors.white
                  : Colors.black,
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}