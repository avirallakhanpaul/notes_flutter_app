import "package:flutter/material.dart";
import 'package:notes_app/models/note.dart';
import "package:provider/provider.dart";

import "../../../providers/theme_provider.dart";
import "../../note_screen/note_screen.dart";

class NoteCard extends StatelessWidget {

  final Note note;
  // final String id;

  NoteCard(this.note);

  @override
  Widget build(BuildContext context) {

    final noteId = note.id;
    final noteTitle = note.title;
    // final noteDesc = note.desc;
    final noteLightColor = note.lightColor;
    final noteDarkColor = note.darkColor;

    // final noteProvider = Provider.of<NoteProvider>(context);
    // final noteId = noteProvider.items[index].id;
    // final Map<String, dynamic> note = noteProvider.getNoteById(id);

    // print(note.darkColor);

    return Consumer<ThemeProvider>(
      builder: (ctx, theme, child) {
        print("Noteid: $noteId");
        print("NoteTitle: $noteTitle");
        print("NoteLightColor: $noteLightColor");
        print("NoteDarkColor: $noteDarkColor");
        return Card(
          key: Key(noteId.toString()),
          color: theme.isDarkTheme
          ? Color(noteDarkColor)
          : Color(noteLightColor),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              noteTitle,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                NoteScreen.routeName,
                arguments: note,
              );
            },
          ),
        );
      }
    );
  }
}