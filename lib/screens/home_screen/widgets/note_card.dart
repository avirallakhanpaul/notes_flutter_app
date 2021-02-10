import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../../providers/note_provider.dart";
import "../../../providers/theme_provider.dart";
import "../../note_screen/note_screen.dart";
import "../../../helpers/arguments.dart";

class NoteCard extends StatelessWidget {

  final int index;

  NoteCard(this.index);

  @override
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);
    
    final noteId = noteProvider.items[index].id;
    final note = noteProvider.getNoteById(noteId);

    print(note.darkColor);

    return Consumer<ThemeProvider>(
      builder: (ctx, theme, child) {
        print(theme.isDarkTheme);
        return Card(
          key: Key(index.toString()),
          color: theme.isDarkTheme
          ? Color(note.darkColor)
          : Color(note.lightColor),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              note.title,
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
                arguments: Args(
                  index, 
                  note.lightColor,
                  note.darkColor,
                ),
              );
            },
          ),
        );
      }
    );
  }
}