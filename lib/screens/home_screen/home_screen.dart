import "package:flutter/material.dart";
import 'package:notes_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

import "./widgets/note_card.dart";
import "./widgets/add_note_card.dart";

class HomeScreen extends StatelessWidget {

  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {

    // final snackBar = SnackBar(
    //   content: Text(
    //     "Note Deleted",
    //     style: TextStyle(
    //       fontSize: 16,
    //       fontFamily: "Poppins",
    //       // fontWeight: FontWeight.
    //     ),
    //   ),
    //   backgroundColor: Colors.red.shade900,
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes",
        style: TextStyle(
          fontSize: 24,
          fontFamily: "Poppins",
          // fontWeight: FontWeight.w100,
        )),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false).addNote();
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Builder(
        builder: (ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
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
                        child: Center(
                          child: const Text("No notes found :("),
                        ),
                        builder: (ctx, note, child) => note.items.length <= 0
                          ? child 
                          : ListView.builder(
                            itemCount: note.items.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            // scrollDirection: Axis.vertical,
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
                                    onDismissed: (direction) {

                                      Scaffold.of(ctx).removeCurrentSnackBar();

                                      final deletedNote = note.items[index];

                                      note.deleteNote(
                                        tableName: "user_notes",
                                        id: note.items[index].id,
                                      );

                                      return Scaffold.of(ctx).      showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Note Deleted",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: "Poppins",
                                            ),
                                          ),
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
}