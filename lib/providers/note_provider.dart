import 'dart:math';

import "package:flutter/material.dart";

import '../helpers/db_helper.dart';
import '../models/note.dart';

// enum NoteColors {
//   blue,
//   darkBlue,
//   red,
//   yellow,
//   orange,
//   green,
//   darkGreen,
//   purple,
// }

class NoteProvider with ChangeNotifier {

  int noteColor;
  var random = Random();

  List<Note> _items = [];
  
  List<Note> get items {
    return [..._items];
  }

  void addNote({int index, Note deletedNote, String noteTitle = "Title", String noteDesc = "Description..."}) {

    switch(random.nextInt(9)) {

      case 1: noteColor = 0xFF2980b9;
        break;
      case 2: noteColor = 0xFF2c3e50;
        break;
      case 3: noteColor = 0xFFc0392b;
        break;
      case 4: noteColor = 0xFFf1c40f;
        break;
      case 5: noteColor = 0xFFf39c12;
        break;
      case 6: noteColor = 0xFF27ae60;
        break;
      case 7: noteColor = 0xFF16a085;
        break;
      case 8: noteColor = 0xFF8e44ad;
        break;
    }
    
    final newNote = Note(
      id: DateTime.now().toString(),
      title: noteTitle,
      desc: noteDesc,
      color: noteColor,
    );

    if(index != null) {
      _items.insert(index, deletedNote);
    } else {
      _items.add(newNote);
    }


    notifyListeners();

    if(index != null) {
      DBHelper.insertToDb(
        "user_notes", 
        {
          "id": deletedNote.id,
          "title": deletedNote.title,
          "desc": deletedNote.desc,
          "color": deletedNote.color,
        },
      );
    } else {
      DBHelper.insertToDb(
        "user_notes", 
        {
          "id": newNote.id,
          "title": newNote.title,
          "desc": newNote.desc,
          "color": noteColor,
        },
      );
    }
  }

  Future<void> fetchOrSetNotes() async {

    final dataList = await DBHelper.getData("user_notes");

    _items = dataList.map((item) {
      return Note(
        id: item["id"],
        title: item["title"],
        desc: item["desc"],
        color: item["color"],
      );
    }).toList();

    notifyListeners();
  }

  Future<void> updateNoteTitle({String tableName, String id, String newTitle}) async {

    final database = await DBHelper.database(tableName);

    database.update(
      tableName,
      {
        "title": newTitle,
      },
      where: "id = ?",
      whereArgs: [id],
    );

    fetchOrSetNotes();
    notifyListeners();
  }

  Future<void> updateNoteDesc({String tableName, String id, String newDesc}) async {

    final database = await DBHelper.database(tableName);

    database.update(
      tableName,
      {
        "desc": newDesc,
      },
      where: "id = ?",
      whereArgs: [id],
    );

    fetchOrSetNotes();
    notifyListeners();
  }

  Future<void> deleteNote({String tableName, String id}) async {

    final database = await DBHelper.database(tableName);

    database.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );

    fetchOrSetNotes();
    notifyListeners();
  }

  Note getNoteById(String id) {
    return _items.firstWhere((note) => note.id == id);
  }
}