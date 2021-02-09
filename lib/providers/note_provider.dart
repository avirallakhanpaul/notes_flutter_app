import 'dart:math';

import "package:flutter/material.dart";
import 'package:notes_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/db_helper.dart';
import '../helpers/arguments.dart';
import '../models/note.dart';
import '../screens/note_screen/note_screen.dart';

class NoteProvider with ChangeNotifier {

  int noteColor;
  var random = Random();

  List<Note> _items = [];
  
  List<Note> get items {
    return [..._items];
  }

  bool isDarkMode;

  void addNote({BuildContext context, int index, Note deletedNote, String noteTitle = "Title", String noteDesc = ""}) {

    print("isDarkMode(NoteProv): $isDarkMode");

    switch(random.nextInt(8)) {

      case 0: noteColor = isDarkMode ? 0xFF64B5F6 : 0xFF2196F3;
        break;
      case 1: noteColor = isDarkMode ? 0xFF78909C : 0xFF2C3E50;
        break;
      case 2: noteColor = isDarkMode ? 0xFFEF5350 : 0xFFE53935;
        break;
      case 3: noteColor = isDarkMode ? 0xFFFFCA28 : 0xFFF1C40F;
        break;
      case 4: noteColor = isDarkMode ? 0xFFFFA726 : 0xFFFF9800;
        break;
      case 5: noteColor = isDarkMode ? 0xFF66BB6A : 0xFF4CAF50;
        break;
      case 6: noteColor = isDarkMode ? 0xFF9CCC65 : 0xFF16A085;
        break;
      case 7: noteColor = isDarkMode ? 0xFFBA68C8 : 0xFF8E44AD;
        break;
    }
    
    final newNote = Note(
      id: DateTime.now().toString(),
      title: noteTitle,
      desc: noteDesc,
      color: noteColor,
    );

    if(index != null) { // UNDO Operation
      _items.insert(index, deletedNote);
    } else {

      _items.add(newNote);

      final lastNoteIndex = _items.length - 1;

      Navigator.of(context).pushNamed(
        NoteScreen.routeName,
        arguments: Args(lastNoteIndex, newNote.color),
      );
    }

    notifyListeners();

    if(index != null) { // UNDO Operation
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

    if(newTitle == "" || newTitle.isEmpty) {
      newTitle = "Title";
    }

    database.update(
      tableName,
      {
        "title": newTitle,
      },
      where: "id = ?",
      whereArgs: [id],
    );

    await fetchOrSetNotes();
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

    await fetchOrSetNotes();
    notifyListeners();
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

  Note getNoteById(String id) {
    return _items.firstWhere((note) => note.id == id);
  }
}