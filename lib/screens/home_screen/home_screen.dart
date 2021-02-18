import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import "package:flutter/material.dart";
import 'package:notes_app/models/note.dart';
import 'package:provider/provider.dart';

import 'package:notes_app/providers/auth_provider.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:notes_app/providers/theme_provider.dart';
import 'package:notes_app/common_widgtes/delete_alert_dialog.dart';
import "./widgets/note_card.dart";

class HomeScreen extends StatefulWidget {

  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Query _dbRef;

  // @override
  // void initState() {
  //   super.initState();
    
  // }

  @override
  Widget build(BuildContext context) {
    
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);
    _dbRef = FirebaseDatabase.instance.reference().child("notes")
    .orderByChild("userId");
    
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
            leading: Transform.scale(
              scale: 1.2,
              child: Switch(
                value: theme.isDarkTheme,
                onChanged: ((_) => theme.toggleTheme()),
                inactiveTrackColor: Color(0xFF4D4D4D),
                inactiveThumbColor: Color(0xFF78909C),
                inactiveThumbImage: AssetImage(
                  "assets/icons/lightmode.png",
                ),
                activeTrackColor: Color(0xFF4D4D4D),
                activeColor: Color(0xFF42A5F5),
                activeThumbImage: AssetImage(
                  "assets/icons/darkmode.png",
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  color: theme.isDarkTheme
                  ? Colors.white
                  : Colors.black,
                  size: 30,
                ),
                onPressed: () => authProvider.signOut(),
              ),
            ],
            centerTitle: true,
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => noteProvider.addNote(context: context),
            backgroundColor: theme.isDarkTheme
            ? Color(0xFF64B5F6)
            : Color(0xFF2196F3),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                      Consumer<AuthProvider>(
                        builder: (ctx, auth, index) {
                          print("HmScrn Id: ${auth.userId}");
                          return FirebaseAnimatedList(
                            query: _dbRef.equalTo(auth.userId),
                            defaultChild: Center(
                              child: CircularProgressIndicator(),
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, snapshot, animation, i) {
                              snapshot.value == null ? print("Snapshot is null") :
                              print("HmScreen ID: ${auth.userId}");
                              Map<dynamic, dynamic> noteData = snapshot.value;
                              print(noteData);
                              return Consumer<NoteProvider>(
                                builder: (ctx, note, child) => noteData.keys.length <= 0
                                  ? Container()
                                  : ListView.builder(
                                    itemCount: 1,
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
                                                noteIndex: index.toString(),
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
                                            child: NoteCard(
                                              // noteData["id"],
                                              Note(
                                                id: noteData["id"].toString(),
                                                userId: noteData["userId"],
                                                title: noteData["title"],
                                                desc: noteData["desc"],
                                                lightColor: noteData["lightColor"],
                                                darkColor: noteData["darkColor"],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      );
                                    }
                                  ),
                              );
                            },
                          );
                        }
                      ),
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