import "package:flutter/material.dart";
import 'package:notes_app/helpers/arguments.dart';
import 'package:notes_app/helpers/note_screen_agruments.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:notes_app/screens/reminder/reminder_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

import "../../providers/note_provider.dart";
import "../../common_widgtes/delete_alert_dialog.dart";

enum PopupOptions {
  delete,
  share,
  reminder,
}

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

    final NoteScreenArgumets noteArgs = ModalRoute.of(context).settings.arguments;
    final Note note = noteArgs.note;
    final bool isNewNote = noteArgs.isNewNote ?? true;

    titleController.text = note.title;
    descController.text = note.desc;

    final initialTitleValue = titleController.text;
    final initialDescValue = descController.text;

    void shareNote({@required String title, @required String desc}) {
      if(title.isEmpty && desc.isEmpty) {
        return;
      } else {
        Share.share(
          "$title \n\n$desc \n\nThis note is made using JustNotes app, developed by Aviral Lakhanpaul",
          subject: "$title",
        );
      }
    }

    void addReminder() {
      Navigator.of(context).pushNamed(
        ReminderScreen.routeName,
        arguments: Args(
          index: note.id,
          title: titleController.text,
          desc: descController.text,
          darkColor: note.darkColor,
          lightColor: note.lightColor,
        )
      );
    }

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
      } else if(optSelected == PopupOptions.share) {
        print("Share Option Selected");

        shareNote(
          title: titleController.text,
          desc: descController.text,
        );
      } else if(optSelected == PopupOptions.reminder) {
        print("reminder Option Selected");

        addReminder();
      } else {
        return null;
      }
    }

    void saveNote({bool isPopScope}) async {

      if(titleController.text == initialTitleValue && descController.text == initialDescValue) {
        Navigator.pop(context);
      } else if(titleController.text == "" && descController.text == "") {
        Navigator.pop(context);
        noteProvider.deleteNote(note.id);
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
              brightness: theme.isDarkTheme
              ? Brightness.dark
              : Brightness.light,
              backgroundColor: theme.isDarkTheme
              ? Color(note.darkColor)
              : Color(note.lightColor),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: Colors.white
                ),
                splashRadius: 25,
                tooltip: "Back",
                enableFeedback: true,
                onPressed: () => saveNote(isPopScope: false),
              ),
              title: Consumer<NoteProvider>(
                builder: (ctx, _, child) {
                  return TextField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                    controller: titleController,
                    autofocus: isNewNote
                    ? true
                    : false,
                    onSubmitted: (value) => saveNote(isPopScope: true),
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
                  onPressed: () => saveNote(isPopScope: false),
                  enableFeedback: true,
                  tooltip: "Save",
                  splashRadius: 25,
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
                      PopupMenuItem<PopupOptions>(
                        value: PopupOptions.share,
                        child: ListTile(
                          leading: Icon(
                            Icons.share,
                            color: theme.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                          ),
                          title: Text(
                            "Share",
                            style: TextStyle(
                              color: theme.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<PopupOptions>(
                        value: PopupOptions.reminder,
                        child: ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: theme.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                          ),
                          title: Text(
                            "Reminder",
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
                      onSubmitted: (value) => saveNote(isPopScope: true),
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