import 'dart:math';

import "package:flutter/material.dart";
import "package:firebase_database/firebase_database.dart";
import 'package:notes_app/helpers/note_screen_agruments.dart';

import 'auth_provider.dart';
import '../models/note.dart';
import '../screens/note_screen/note_screen.dart';

class NoteProvider with ChangeNotifier {

  int noteLightColor, noteDarkColor;
  var random = Random();

  final dbRef = FirebaseDatabase.instance.reference();
  String userId;

  bool isDarkMode;

  void setUserId(AuthProvider auth) {
    userId = auth.userId;
  }

  void addNote({BuildContext context, Note deletedNote, String noteTitle = "Title", String noteDesc = ""}) async {

    print("NoteProvider id: $userId");

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
 
    // if(deletedNote == null) { // A New Note is Added
    //   Navigator.of(context).pushNamed(
    //     NoteScreen.routeName,
    //     arguments: newNote,
    //   );
    // }

    notifyListeners();

    if(deletedNote != null) { // UNDO Operation

      final key = deletedNote.id;

      dbRef.child("notes").child(key).set({ // INSERT Operation
        "id": key,
        "userId": deletedNote.userId,
        "title": deletedNote.title,
        "desc": deletedNote.desc,
        "lightColor": deletedNote.lightColor,
        "darkColor": deletedNote.darkColor,
      });
    } else { // Addition of a New Note

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

      newNote.id = id;

      Navigator.of(context).pushNamed(
        NoteScreen.routeName,
        arguments: NoteScreenArgumets(
          note: newNote,
          isNewNote: true,
        ),
      );
    }
  }

  Future<void> updateNote({String idKey, Map<String, dynamic> note}) async {
    await dbRef.child("notes").equalTo(userId).reference().child(idKey).update(note);
  }

  Future<void> deleteNote(String idKey) async {
    print("idKey: $idKey");
    await dbRef.child("notes").equalTo(userId).reference().child(idKey).remove();

    notifyListeners();
    // final database = await DBHelper.database(tableName);

    // await database.delete(
    //   tableName,
    //   where: "id = ?",
    //   whereArgs: [id],
    // );

    // await fetchOrSetNotes();
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