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
        Ink(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade300,
          ),
          child: InkWell(
            onTap: () {
              noteProvider.addNote();
            },
            borderRadius: BorderRadius.circular(10),
              child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                    Icons.add_circle,
                      size: 30,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                    "Add a note",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}