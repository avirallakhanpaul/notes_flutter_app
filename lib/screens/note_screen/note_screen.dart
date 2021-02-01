import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../providers/note_provider.dart';
import '../../helpers/arguments.dart';

enum PopupOptions { delete }

class NoteScreen extends StatefulWidget {

  static const routeName = "/notes";

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);
    final Args noteArgs = ModalRoute.of(context).settings.arguments;

    titleController.text = noteProvider.items[noteArgs.index].title;
    descController.text = noteProvider.items[noteArgs.index].desc;

    final initialTitleValue = titleController.text;
    final initialDescValue = descController.text;
    // print("intial Title -> $initialTitleValue");
    // print("initial Desc -> $initialDescValue");

    void popupMenuAction(optSelected) {

      if(optSelected == PopupOptions.delete) {
        noteProvider.deleteNote(
          tableName: "user_notes",
          id: noteProvider.items[noteArgs.index].id,
        );

        Navigator.of(context).pop();
      }
    }

    void saveNote() {

      print("intial Title -> $initialTitleValue");
      print("initial Desc -> $initialDescValue");

      print("descController -> ${descController.text}");

      if((titleController.text == initialTitleValue) && (descController.text != initialDescValue)) {
        
        noteProvider.updateNoteDesc(
          tableName: "user_notes",
          id: noteProvider.items[noteArgs.index].id,
          newDesc: descController.text,
        );
      } else if((titleController.text != initialTitleValue) && (descController.text == initialDescValue)) {

        noteProvider.updateNoteTitle(
          tableName: "user_notes",
          id: noteProvider.items[noteArgs.index].id,
          newTitle: titleController.text,
        );
      } else if((titleController.text != initialTitleValue) && (descController.text != initialDescValue)) {

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
      } else {
        return;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        saveNote();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(noteArgs.color),
          title: Consumer<NoteProvider>(
            builder: (ctx, note, child) {
              return TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                ),
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  // hintStyle: TextStyle(),
                  fillColor: Colors.white,
                  border: InputBorder.none,
                ),
              );
            }
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              onPressed: () => saveNote(),
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
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0,
              ),
              child: TextField(
                maxLines: null,
                controller: descController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Description..",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    color: Colors.grey.shade500,
                  ),
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Poppins",
                  color: Colors.black,
                  letterSpacing: 0.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}