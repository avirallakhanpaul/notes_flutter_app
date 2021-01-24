import "package:flutter/material.dart";
import 'package:notes_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

import "./widgets/note_card.dart";
import "./widgets/add_note_card.dart";

class HomeScreen extends StatelessWidget {

  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {

    // final noteProvider = ;

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes",
        style: TextStyle(
          fontSize: 24,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w300,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
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
                          return NoteCard(index);
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
      ),
    );
  }
}