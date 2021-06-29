import "package:sqflite/sqflite.dart";

class DBHelper {
  static Future<Database> database(String tableName) async {
    final dir = await getDatabasesPath();
    final path = dir + '$tableName.dart';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
            Create Table $tableName(
              id text primary key,
              title text,
              dateTimeString text
            )
          ''');
      },
    );
  }

  static Future<void> insertToDb(
      String tableName, Map<String, Object> data) async {
    print("Data inside DB function: $data");

    final database = await DBHelper.database(tableName);
    // await database.execute("DROP TABLE IF EXISTS $tableName");

    database.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String tableName,
      {String arg}) async {
    final database = await DBHelper.database(tableName);
    if (arg != null) {
      return await database.query(
        tableName,
        where: "id = ?",
        whereArgs: [arg],
      );
    } else {
      return await database.query(tableName);
    }
  }

  static deleteReminderFromDb(String tableName, String id) async {
    final database = await DBHelper.database(tableName);
    await database.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    print("Reminder of Note id($id) deleted from Database");
  }
}
