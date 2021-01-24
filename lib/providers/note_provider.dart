import "package:flutter/material.dart";
import 'package:notes_app/helpers/db_helper.dart';

import '../models/note.dart';

class NoteProvider with ChangeNotifier {

  int noteCount = 3;

  List<Note> _items = [];
  
  List<Note> get items {
    return [..._items];
  }

  void addNote({String noteTitle = "Title", String noteDesc = "Description..."}) {
    
    final newNote = Note(
      id: DateTime.now().toString(),
      title: noteTitle,
      desc: noteDesc,
    );

    _items.add(newNote);

    notifyListeners();

    DBHelper.insertToDb(
      "user_notes", 
      {
        "id": newNote.id,
        "title": newNote.title,
        "desc": newNote.desc,
      },
    );
  }

  Future<void> fetchOrSetNotes() async {

    final dataList = await DBHelper.getData("user_notes");

    _items = dataList.map((item) {
      return Note(
        id: item["id"],
        title: item["title"],
        desc: item["desc"],
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

    // fetchOrSetNotes();
    notifyListeners();
  }

  Note getNoteById(String id) {
    return _items.firstWhere((note) => note.id == id);
  }
}