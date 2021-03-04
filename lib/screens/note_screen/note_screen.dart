import "package:flutter/material.dart";
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import "../../providers/note_provider.dart";
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
  bool isSaving = false;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {

    final noteProvider = Provider.of<NoteProvider>(context);
    final Note note = ModalRoute.of(context).settings.arguments;

    titleController.text = note.title;
    descController.text = note.desc;

    final initialTitleValue = titleController.text;
    final initialDescValue = descController.text;

    void popupMenuAction(optSelected) async {

      if(optSelected == PopupOptions.delete) {
        print("Del Operation Selected");
        
        final DeleteAlertDialog delAlertDialog = DeleteAlertDialog(
          note: note,
          fromNoteScreen: true,
        );

        showDialog(
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

    void saveNote({bool isPopScope}) async {

      if(titleController.text == initialTitleValue && descController.text == initialDescValue) {
        Navigator.pop(context);
      } else {
        await noteProvider.updateNote(
          idKey: note.id,
          note: {
            "title": titleController.text,
            "desc": descController.text,
            "lightColor": note.lightColor,
            "darkColor": note.darkColor,
          },
        );

        Fluttertoast.showToast(
          msg: "Note Saved",
          fontSize: 16,
          gravity: ToastGravity.SNACKBAR,
          toastLength: Toast.LENGTH_SHORT,
        );

        if(!isPopScope || isPopScope == null) {
          print("No pop Scope");
          Navigator.pop(context);
        } else {
          return;
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        saveNote(isPopScope: true);
        return true;
      },
      child: Consumer<ThemeProvider>(
        builder: (ctx, theme, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: theme.isDarkTheme
              ? Color(note.darkColor)
              : Color(note.lightColor),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white
                ),
                onPressed: () => saveNote(isPopScope: false),
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
                // isSaving 
                // ? CircularProgressIndicator()
                IconButton(
                  icon: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  onPressed: () => saveNote(isPopScope: false),
                ),
                PopupMenuButton<PopupOptions>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  color: theme.isDarkTheme 
                  ? Color(0xFF424242)
                  : Colors.white,
                  onSelected: popupMenuAction,
                  itemBuilder: (ctx) {
                    return <PopupMenuEntry<PopupOptions>>[
                      PopupMenuItem<PopupOptions>(
                        value: PopupOptions.delete,
                        child: ListTile(
                          leading: Icon(
                            Icons.delete,
                            color: theme.isDarkTheme
                            ? Color(0xFFEF5350)
                            : Colors.red,
                          ),
                          title: Text(
                            "Delete",
                            style: TextStyle(
                              color: theme.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                            ),
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