import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../providers/note_provider.dart';

class AddNoteCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);

    return Column(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.grey.shade200,
          elevation: 0,
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            leading: Icon(
              Icons.add_circle,
              color: Colors.grey.shade900,
              size: 30,
            ),
            title: Text(
              "Add a note",
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
            ),
            onTap: () => noteProvider.addNote(context: context),
          ),
        ),
      ],
    );
  }
}