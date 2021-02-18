import 'dart:math';

import "package:flutter/material.dart";
import "package:firebase_database/firebase_database.dart";
import 'package:notes_app/providers/auth_provider.dart';

import '../helpers/db_helper.dart';
import '../models/note.dart';
import '../screens/note_screen/note_screen.dart';

class NoteProvider with ChangeNotifier {

  int noteLightColor, noteDarkColor;
  var random = Random();

  final dbRef = FirebaseDatabase.instance.reference();
  String userId;

  List<Note> _items = [];
  List<Note> items = [];

  bool isDarkMode;

  void setUserId(AuthProvider auth) {
    userId = auth.userId;
  }

  void addNote({BuildContext context, int index, Note deletedNote, String noteTitle = "Title", String noteDesc = ""}) async {

    print(userId);

    switch(random.nextInt(8)) {

      case 0: 
      noteLightColor = 0xFF2196F3;
      noteDarkColor = 0xFF64B5F6;
        break;
      case 1: 
      noteLightColor = 0xFF2C3E50;
      noteDarkColor = 0xFF78909C;
        break;
      case 2: 
      noteLightColor = 0xFFE53935;
      noteDarkColor = 0xFFEF5350;
        break;
      case 3: 
      noteLightColor = 0xFFF1C40F;
      noteDarkColor = 0xFFFFCA28;
        break;
      case 4: 
      noteLightColor = 0xFFFF9800;
      noteDarkColor = 0xFFFFA726;
        break;
      case 5: 
      noteLightColor = 0xFF4CAF50;
      noteDarkColor = 0xFF66BB6A;
        break;
      case 6: 
      noteLightColor = 0xFF16A085;
      noteDarkColor = 0xFF9CCC65;
        break;
      case 7: 
      noteLightColor = 0xFF8E44AD;
      noteDarkColor = 0xFFBA68C8;
        break;
    }
    
    final newNote = Note(
      id: "",
      userId: userId,
      title: noteTitle,
      desc: noteDesc,
      lightColor: noteLightColor,
      darkColor: noteDarkColor,
    );

    if(index != null) { // UNDO Operation
      _items.insert(index, deletedNote);
    } else {

      // final lastNoteIndex = _items.length;
      
      Navigator.of(context).pushNamed(
        NoteScreen.routeName,
        arguments: newNote,
      );

      _items.add(newNote);
    }

    notifyListeners();

    if(index != null) { // UNDO Operation
      DBHelper.insertToDb(
        "user_notes", 
        {
          "id": deletedNote.id,
          "title": deletedNote.title,
          "desc": deletedNote.desc,
          "lightColor": deletedNote.lightColor,
          "darkColor": deletedNote.darkColor,
        },
      );
    } else {

      // .equalTo(userId).reference()

      // dbRef.child("Notes").push().set({ // INSERT Operation
      //   "id": newNote.id,
      //   "title": newNote.title,
      //   "desc": newNote.desc,
      //   "lightColor": newNote.lightColor,
      //   "darkColor": newNote.darkColor,
      // });

      final key = dbRef.child("notes").push().path;
      final id = key.substring(6, key.length).trim();

      dbRef.child(key).set({ // INSERT Operation
        "id": id,
        "userId": newNote.userId,
        "title": newNote.title,
        "desc": newNote.desc,
        "lightColor": newNote.lightColor,
        "darkColor": newNote.darkColor,
      });
    }
  }

  Future<void> fetchOrSetNotes() async {

  //   final dataList = await DBHelper.getData("user_notes");

  //   _items = dataList.map((item) {
  //     return Note(
  //       id: item["id"],
  //       title: item["title"],
  //       desc: item["desc"],
  //       lightColor: item["lightColor"],
  //       darkColor: item["darkColor"],
  //     );
  //   }).toList();

  //   await dbRef.once().then((DataSnapshot dataSnapshot) {

  //     print(dataSnapshot.value["Notes"]["id"]);

  //     var values = dataSnapshot.data.value;

  //     values.forEach((val) {
  //       print(val);
  //     });

  //     for(var value in values) {
  //       print(value);

  //       _items.add(
  //         Note(
  //           id: value["id"],
  //           title: value["title"],
  //           desc: value["desc"],
  //           lightColor: value["lightColor"],
  //           darkColor: value["darkColor"],
  //         ),
  //       );

  //     _items = values.map((value) {
  //       print(value["id"]);
  //       return Note(
  //         id: value["id"],
  //         title: value["title"],
  //         desc: value["desc"],
  //         lightColor: value["lightColor"],
  //         darkColor: value["darkColor"],
  //       );
  //     });
  //   });

  //   await dbRef.once().then((DataSnapshot dataSnapshot) {
  //     var keys = dataSnapshot.value.keys;
  //     var values = dataSnapshot.value;

  //     List list = [];

  //     list = keys;

  //     list.forEach((value) {
  //       print(value);
  //     });

  //     for(var key in keys) {

  //       print("$key(key): ${values[key]}");
  //     }
  //   });
  //   notifyListeners();
  }

  Future<void> updateNote({String idKey, Map<String, dynamic> note}) async {
    // print("idKey: $idKey");
    // print("User ID(NoteProvider): $userId");
    await dbRef.child("notes").equalTo(userId).reference().child(idKey).update(note);
    // dbRef.child("Notes").reference().push()
  }

  Future<void> deleteNote({String tableName, String id}) async {

    final database = await DBHelper.database(tableName);

    await database.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );

    await fetchOrSetNotes();
    // notifyListeners();
  }

  // void switchNoteColor({String tableName}) async {

  //   final database = await DBHelper.database(tableName);

  //   await database.update(
  //     tableName,
  //     {

  //     },
  //   );
  // }

  // Future<DataSnapshot> getNoteById(String id) async {
  //   return await dbRef.child("Notes").equalTo(userId).reference().child(id).once().then((val) => val);
  // }
}