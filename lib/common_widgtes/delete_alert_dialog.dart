import "package:flutter/material.dart";
import "package:provider/provider.dart";

import '../models/note.dart';
import '../providers/theme_provider.dart';
import "../providers/note_provider.dart";

class DeleteAlertDialog extends StatelessWidget {

  final Note note;
  final bool fromNoteScreen;

  DeleteAlertDialog({@required this.note, this.fromNoteScreen});

  @override
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);

    void delNote() async {
      print("delNote Function");

      if(fromNoteScreen) {

        await noteProvider.deleteNote(note.id);

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pop(true);
      }
    }

    return Consumer<ThemeProvider>(
      builder: (ctx, theme, child) {
        return AlertDialog(
          backgroundColor: theme.isDarkTheme
          ? Color(0xFF424242)
          : Colors.white,
          title: Text(
            "Are you sure?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 20,
              color: theme.isDarkTheme
              ? Colors.white 
              : Colors.black,
            ),
          ),
          content: Text(
            "Remove ${note.title} permanently?",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              color: theme.isDarkTheme
              ? Colors.white 
              : Colors.black,
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
                  color: theme.isDarkTheme
                  ? Colors.white
                  : Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async => delNote(),
              style: ElevatedButton.styleFrom(
                primary: theme.isDarkTheme
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
        );
      }
    );
  }
}