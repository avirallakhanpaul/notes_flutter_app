import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/note_provider.dart";
import "../screens/home_screen/home_screen.dart";

class DeleteAlertDialog extends StatelessWidget {

  final int noteIndex;

  DeleteAlertDialog(this.noteIndex);

  @override
  AlertDialog build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);

    return AlertDialog(
      title: Text(
        "Delete?",
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      content: Text(
        "Remove ${noteProvider.items[noteIndex].title} permanently?",
        style: TextStyle(
          fontFamily: "Poppins",
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      actions: [
        RaisedButton(
          onPressed: () async {
            await noteProvider.deleteNote(
              tableName: "user_notes",
              id: noteProvider.items[noteIndex].id,
            );
            // Navigator.of(context).pop();
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          },
          color: Colors.red.shade700,
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
          onPressed: () => Navigator.of(context).pop(),
          splashColor: Colors.grey.shade300,
          child: Text(
            "Cancel",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}