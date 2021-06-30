import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import "./widgets/note_card.dart";
import '../../common_widgtes/delete_alert_dialog.dart';
import '../../models/note.dart';
import '../../providers/note_provider.dart';
import '../../providers/theme_provider.dart';

enum PopupOptions { signout }

class HomeScreen extends StatefulWidget {

  static const routeName = "/home";

  final Function signOutFunction;
  final Function settingsFunction;
  HomeScreen({this.signOutFunction, this.settingsFunction});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  FirebaseDatabase firebaseInstance;
  
  AnimationController _animationController;
  AnimationController _sizeAnimController;
  Animation _sizeAnimation;
  CurvedAnimation _sizeCurvedAnimation;

  Tween<Offset> tweenOffset = Tween<Offset>(
    begin: Offset(1,0),
    end: Offset(0,0),
  );

  @override
  void initState() {
    super.initState();

    firebaseInstance = FirebaseDatabase.instance;
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _sizeAnimController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _sizeCurvedAnimation = CurvedAnimation(
      parent: _sizeAnimController,
      curve: Curves.easeInOut,
    );

    _sizeAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 0.8,
            end: 1.2,
          ), 
          weight: 50,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 1.2,
            end: 0.8,
          ), 
          weight: 50,
        ),
      ],
    ).animate(_sizeCurvedAnimation);

    _animationController.forward();

    _animationController.addListener(() {
      print(_animationController.value);
      // setState(() {});
    });

    _animationController.addStatusListener((status) {
      print(_animationController.status);
    });

    _sizeAnimController.addStatusListener((status) {
      print("Size Animation Status: $status");
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);
    
    return Consumer<ThemeProvider>(
      builder: (ctx, theme, _) {
        return Scaffold(
          appBar: AppBar(
            brightness: theme.isDarkTheme
            ? Brightness.dark
            : Brightness.light,
            backgroundColor: theme.isDarkTheme
            ? Color(0xFF121212)
            : Colors.white,
            title:TweenAnimationBuilder(
              duration: Duration(milliseconds: 1200),
              tween: Tween<double>(
                begin: 0,
                end: 1,
              ),
              child: Row(
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
              builder: (ctx, val, child) {
                return Opacity(
                  opacity: val,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 20 - (val * 20),
                    ),
                    child: child,
                  ),
                );
              }
            ),
            leading: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: theme.isDarkTheme
                ? Colors.white
                : Colors.black,
                size: 30,
              ),
              splashRadius: 25,
              tooltip: "Settings",
              enableFeedback: true,
              onPressed: widget.settingsFunction,
            ),
            actions: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (ctx, child) {
                  return Transform.scale(
                    scale: _sizeAnimation.value,
                    child: IconButton(
                      icon: theme.isDarkTheme
                      ? Opacity(
                        opacity: _animationController.value,
                        child: SvgPicture.asset(
                          "assets/icons/moon_fill.svg",
                          color: Colors.white,
                        ),
                      )
                      : SvgPicture.asset("assets/icons/moon_outline.svg"),
                      splashRadius: 25,
                      enableFeedback: true,
                      tooltip: theme.isDarkTheme
                      ? "Enable Light Mode"
                      : "Enable Dark Mode",
                      onPressed: () => {
                        if(theme.isDarkTheme) {
                          _animationController.reverse(),
                          _sizeAnimController.forward(),
                        } else {
                          _animationController.forward(),
                          _sizeAnimController.reverse(),
                        },
                        theme.toggleTheme(),
                      }
                    ),
                  );
                },
              ),
            ],
            centerTitle: true,
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => noteProvider.addNote(context: context),
            materialTapTargetSize: MaterialTapTargetSize.padded,
          elevation: 10,
            tooltip: "Add a note",
            backgroundColor: theme.isDarkTheme
            ? Color(0xFF64B5F6)
            : Color(0xFF2196F3),
            child: Icon(
              Icons.add,
              color: theme.isDarkTheme ? Color(0xFF121212) : Colors.white,
              size: 30,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          backgroundColor: theme.isDarkTheme
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
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if(snapshot.connectionState == ConnectionState.none) {
                            return Text("No Internet Connection");
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

                                            ScaffoldMessenger.of(ctx).removeCurrentSnackBar();

                                            final deletedNote = noteData[index];

                                            note.deleteNote(noteData[index]["id"]);

                                            return ScaffoldMessenger.of(ctx).showSnackBar(
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