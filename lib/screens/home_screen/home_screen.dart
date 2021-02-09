import "package:flutter/material.dart";
import 'package:notes_app/common_widgtes/delete_alert_dialog.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import "./widgets/note_card.dart";
import "./widgets/add_note_card.dart";

class HomeScreen extends StatelessWidget {

  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {

    // final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // await themeProvider.initTheme();
    // final isDarkMode = themeProvider.isDarkThemeEnabled;

    // void setHomeTheme() async {
      
    //   await themeProvider.toggleAndSetTheme();
    //   setState(() {
    //     isDarkMode = themeProvider.isDarkThemeEnabled;
    //   });
    // }

    // isDarkMode = context.watch<ThemeProvider>().isDarkThemeEnabled;

    // isDarkMode = Provider.of<ThemeProvider>(context).getTheme();

    // print("Home Screen: $isDarkMode");
    
    return Consumer<ThemeProvider>(
      builder: (ctx, theme, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.isDarkTheme
            ? Color(0xFF121212)
            : Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Just",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Poppins",
                    color: theme.isDarkTheme
                    ? Colors.white
                    : Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Notes",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: theme.isDarkTheme
                    ? Color(0xFF42A5F5)
                    : Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                theme.isDarkTheme
                ? Icons.lightbulb
                : Icons.lightbulb_outline,
                size: 30,
                color: theme.isDarkTheme
                ? Colors.white
                : Color(0xFF121212),
              ),
              onPressed: () => theme.toggleTheme(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                  color: theme.isDarkTheme
                  ? Colors.white
                  : Colors.black,
                ),
                onPressed: () {
                  Provider.of<NoteProvider>(context, listen: false).addNote(context: context);
                },
              ),
            ],
            centerTitle: true,
            elevation: 0,
          ),
          backgroundColor: theme.isDarkTheme == true
            ? Color(0xFF121212) 
            : Colors.white,
          body: Builder(
            builder: (ctx) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      FutureBuilder(
                        future: Provider.of<NoteProvider>(context, listen: false).fetchOrSetNotes(),
                        builder: (ctx, snapshot) {
                          return snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                            child: CircularProgressIndicator(),
                          )
                          : Consumer<NoteProvider>(
                            builder: (ctx, note, child) => note.items.length <= 0
                              ? Container()
                              : ListView.builder(
                                itemCount: note.items.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return Column(
                                    children: <Widget>[
                                      Dismissible(
                                        key: UniqueKey(),
                                        background: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          color: Colors.red.shade700,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 15,
                                            ),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (direction) async {

                                          final delAlertDialog = DeleteAlertDialog(
                                            noteIndex: index,
                                            fromNoteScreen: false,
                                          );

                                          return await showDialog(
                                            context: context,
                                            builder: (context) => delAlertDialog,
                                          );
                                        },
                                        onDismissed: (direction) {

                                          Scaffold.of(ctx).removeCurrentSnackBar();

                                          final deletedNote = note.items[index];

                                          note.deleteNote(
                                            tableName: "user_notes",
                                            id: note.items[index].id,
                                          );

                                          return Scaffold.of(ctx).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Note Deleted",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                              duration: Duration(seconds: 3),
                                              backgroundColor: Colors.red.shade900,
                                              action: SnackBarAction(
                                                label: "Undo",
                                                onPressed: () {
                                                  note.addNote(
                                                    index: index,
                                                    deletedNote: deletedNote,
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                        child: NoteCard(index),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  );
                                }
                              ),
                          );
                        }
                      ),
                      AddNoteCard(),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }
}