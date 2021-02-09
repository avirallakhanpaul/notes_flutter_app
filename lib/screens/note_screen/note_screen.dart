import "package:flutter/material.dart";
import 'package:notes_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import "../../providers/note_provider.dart";
import "../../helpers/arguments.dart";
import "../../common_widgtes/delete_alert_dialog.dart";

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

    void popupMenuAction(optSelected) async {

      if(optSelected == PopupOptions.delete) {
        
        final DeleteAlertDialog delAlertDialog = DeleteAlertDialog(
          noteIndex: noteArgs.index,
          fromNoteScreen: true,
        );

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return delAlertDialog;
          },
        );

        // print("After Deletion");
      } else {
        return null;
      }
    }

    void saveNote() {

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

      Fluttertoast.showToast(
        msg: "Note Saved",
        fontSize: 16,
        gravity: ToastGravity.SNACKBAR,
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    return WillPopScope(
      onWillPop: () async {
        saveNote();
        return true;
      },
      child: Consumer<ThemeProvider>(
        builder: (ctx, theme, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(noteArgs.color),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white
                ),
                onPressed: () => {
                  saveNote(),
                  Navigator.of(context).pop(),
                }
              ),
              title: Consumer<NoteProvider>(
                builder: (ctx, note, child) {
                  return TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                    controller: titleController,
                    decoration: InputDecoration(
                      // hintText: "Title",
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
                  onPressed: () {
                    saveNote();
                    Navigator.of(context).pop();
                  }
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
                          title: const Text(
                            "Delete",
                          ),
                        ),
                      ),
                    ];
                  }
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                color: theme.isDarkTheme
                ? Color(0xFF121212)
                : Colors.white,
              ),
              child: ListView(
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
                        hintText: "Description",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: theme.isDarkTheme
                          ? Colors.grey.shade700
                          : Colors.grey.shade500,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        color: theme.isDarkTheme
                        ? Colors.white.withOpacity(0.9)
                        : Colors.black,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}