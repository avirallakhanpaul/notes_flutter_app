import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';
import '../helpers/arguments.dart';

enum PopupOptions { delete }

class NoteScreen extends StatelessWidget {

  static const routeName = "/notes";

  @override 
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);
    final Args noteArgs = ModalRoute.of(context).settings.arguments;

    // final titleController = TextEditingController(text: noteProvider.items[noteIndex].title,);

    final titleController = TextEditingController();
    final descController = TextEditingController(text: noteProvider.items[noteArgs.index].desc);

    void popupMenuAction(optSelected) {

      if(optSelected == PopupOptions.delete) {
        noteProvider.deleteNote(
          tableName: "user_notes",
          id: noteProvider.items[noteArgs.index].id,
        );

        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Consumer<NoteProvider>(
          builder: (ctx, note, child) {
            return TextField(
            controller: titleController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              border: InputBorder.none,
              hintText: note.items[noteArgs.index].title,
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w700,
                )
              ),
            );
          }
        ),
        elevation: 0,
        // title: Text(
        //   noteProvider.items[noteIndex].title,
        //   style: TextStyle(
        //     fontSize: 20,
        //     fontFamily: "Poppins",
        //     fontWeight: FontWeight.w500,
        //     color: Colors.white,
        //   ),
        // ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.edit,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},
          // ),
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {

              if((titleController.text == null || titleController.text.isEmpty) && (descController.text != null || descController.text.isNotEmpty)) {

                noteProvider.updateNoteDesc(
                  tableName: "user_notes",
                  id: noteProvider.items[noteArgs.index].id,
                  newDesc: descController.text,
                );
              } else if((titleController.text != null || titleController.text.isNotEmpty) && (descController.text == null || descController.text.isEmpty)) {

                noteProvider.updateNoteTitle(
                  tableName: "user_notes",
                  id: noteProvider.items[noteArgs.index].id,
                  newTitle: titleController.text,
                );
              } else if((titleController.text == null || titleController.text.isEmpty) && (descController.text == null || descController.text.isEmpty)) {
                return;
              } else {
                
                noteProvider.updateNoteTitle(
                  tableName: "user_notes",
                  id: noteProvider.items[noteArgs.index].id,
                  newTitle: titleController.text,
                );

                noteProvider.updateNoteDesc(
                  tableName: "user_notes",
                  id: noteProvider.items[noteArgs.index].id,
                  newDesc: descController.text,
                );
              }
            },
          ),
          PopupMenuButton<PopupOptions>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: popupMenuAction,
            itemBuilder: (ctx) {
              return <PopupMenuEntry<PopupOptions>>[
                const PopupMenuItem<PopupOptions>(
                  value: PopupOptions.delete,
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: Text(
                      "Delete",
                    ),
                  ),
                ),
              ];
            }
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.more_vert,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {},
          // ),
        ],
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: TextField(
              maxLines: null,
              controller: descController,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 18,
                fontFamily: "Poppins",
                color: Colors.black,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ),
      ),
    );
  }
}