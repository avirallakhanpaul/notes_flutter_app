import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import "./widgets/note_card.dart";
import '../../common_widgtes/signout_alert_dialog.dart';
import '../../common_widgtes/delete_alert_dialog.dart';
import '../../models/note.dart';
import '../../providers/note_provider.dart';
import '../../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {

  static const routeName = "/home";

  final Function signOutFunction;
  HomeScreen({this.signOutFunction});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseDatabase firebaseInstance;

  @override
  void initState() {
    firebaseInstance = FirebaseDatabase.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // FirebaseDatabase firebaseInstance = FirebaseDatabase.instance;
    
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    
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
                Icons.exit_to_app_outlined,
                color: theme.isDarkTheme
                ? Colors.white
                : Colors.black,
                size: 30,
              ),
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (ctx) => SignoutAlertDialog(signOutFunction: widget.signOutFunction,),
                );
              },
            ),
            actions: [
              Transform.scale(
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
                      noteProvider.userId == null
                      ? Container()
                      :
                      StreamBuilder(
                        stream: firebaseInstance
                        .reference()
                        .child("notes")
                        .orderByChild("userId")
                        .equalTo(noteProvider.userId)
                        .onValue,
                        builder: (BuildContext ctx, AsyncSnapshot<Event> snapshot) {
                          // debugPrint("Snapshot DATA: ${snapshot.data.snapshot.value}");
                          // debugPrint("Snapshot.data.snapshot: ${snapshot.data.snapshot}");
                          // debugPrint(snapshot.connectionState.toString());
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if(snapshot.connectionState == ConnectionState.active && snapshot.data.snapshot.value == null) {
                            debugPrint("No Data");
                            return Container();
                          } else {
                            // debugPrint("Snapshot Value = ${snapshot.data.snapshot.value.values.toList()}");
                            List<dynamic> noteData = snapshot.data.snapshot.value.values.toList();
                            return Consumer<NoteProvider>(
                              builder: (ctx, note, child) => noteData.length <= 0
                                ? Container()
                                : ListView.builder(
                                  itemCount: noteData.length,
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

                                            debugPrint("NoteData MAP: ${noteData[index]}");

                                            final delAlertDialog = DeleteAlertDialog(
                                              note: Note.fromMap(noteData[index]),
                                              fromNoteScreen: false,
                                            );

                                            return await showDialog(
                                              context: context,
                                              builder: (context) => delAlertDialog,
                                            );
                                          },
                                          onDismissed: (direction) {

                                            Scaffold.of(ctx).removeCurrentSnackBar();

                                            final deletedNote = noteData[index];

                                            note.deleteNote(noteData[index]["id"]);

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
                                                      deletedNote: Note.fromMap(deletedNote),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          child: NoteCard(
                                            Note.fromMap(noteData[index]),
                                            // Note(
                                            //   id: noteData[index]["id"].toString(),
                                            //   userId: noteData[index]["userId"],
                                            //   title: noteData[index]["title"],
                                            //   desc: noteData[index]["desc"],
                                            //   lightColor: noteData[index]["lightColor"],
                                            //   darkColor: noteData[index]["darkColor"],
                                            // ),
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
                          }
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