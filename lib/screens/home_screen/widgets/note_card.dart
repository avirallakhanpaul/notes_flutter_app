import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../providers/note_provider.dart';
import '../../note_screen.dart';

class NoteCard extends StatelessWidget {

  final int index;

  NoteCard(this.index);

  @override
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);
    
    final noteId = noteProvider.items[index].id;
    final note = noteProvider.getNoteById(noteId);

    return Column(
      children: <Widget>[
        Ink(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue.shade700,
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                NoteScreen.routeName,
                arguments: index,
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Text(
                note.title,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}