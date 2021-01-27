import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../providers/note_provider.dart';
import '../../note_screen.dart';
import '../../../helpers/arguments.dart';

class NoteCard extends StatelessWidget {

  final int index;

  NoteCard(this.index);

  @override
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);
    final Size mediaQuery = MediaQuery.of(context).size;
    
    final noteId = noteProvider.items[index].id;
    final note = noteProvider.getNoteById(noteId);

    // return Ink(
    //   width: double.infinity,
    //   height: 55,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: Color(note.color),
    //   ),
    //   child: InkWell(
    //     onTap: () {
    //       Navigator.of(context).pushNamed(
    //         NoteScreen.routeName,
    //         arguments: Args(index, note.color),
    //       );
    //     },
    //     borderRadius: BorderRadius.circular(10),
    //     child: Padding(
    //       padding: EdgeInsets.symmetric(
    //         horizontal: 16,
    //         vertical: 14,
    //       ),
    //       child: Text(
    //         note.title,
    //         style: TextStyle(
    //           fontSize: 18,
    //           fontFamily: "Poppins",
    //           fontWeight: FontWeight.w500,
    //           color: Colors.white,
    //         ),
    //       ),
    //     ),
    //   ),
    // );



    return Card(
      key: Key(index.toString()),
      color: Color(note.color),
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
            arguments: Args(index, note.color),
          );
        },
      ),
    );
  }
}