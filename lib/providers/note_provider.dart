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

  int noteLightColor, noteDarkColor;
  var random = Random();

  List<Note> _items = [];
  
  List<Note> get items {
    return [..._items];
  }

  bool isDarkMode;

  void addNote({BuildContext context, int index, Note deletedNote, String noteTitle = "Title", String noteDesc = ""}) {

    print("isDarkMode(NoteProv): $isDarkMode");

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
      id: DateTime.now().toString(),
      title: noteTitle,
      desc: noteDesc,
      lightColor: noteLightColor,
      darkColor: noteDarkColor,
    );

    if(index != null) { // UNDO Operation
      _items.insert(index, deletedNote);
    } else {

      _items.add(newNote);

      final lastNoteIndex = _items.length - 1;

      Navigator.of(context).pushNamed(
        NoteScreen.routeName,
        arguments: Args(
          lastNoteIndex, 
          newNote.lightColor,
          newNote.darkColor,
        ),
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
          "lightColor": deletedNote.lightColor,
          "darkColor": deletedNote.darkColor,
        },
      );
    } else {
      DBHelper.insertToDb( // INSERT Operation
        "user_notes", 
        {
          "id": newNote.id,
          "title": newNote.title,
          "desc": newNote.desc,
          "lightColor": noteLightColor,
          "darkColor": noteDarkColor,
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
        lightColor: item["lightColor"],
        darkColor: item["darkColor"],
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

  // void switchNoteColor({String tableName}) async {

  //   final database = await DBHelper.database(tableName);

  //   await database.update(
  //     tableName,
  //     {

  //     },
  //   );
  // }

  Note getNoteById(String id) {
    return _items.firstWhere((note) => note.id == id);
  }
}