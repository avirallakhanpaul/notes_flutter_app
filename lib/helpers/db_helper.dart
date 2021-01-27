import "package:sqflite/sqflite.dart";

class DBHelper {

  static Future<Database> database(String tableName) async {

    final dir = await getDatabasesPath();
    final path = dir + '$tableName.dart';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          '''
            Create Table $tableName(
              id text primary key,
              title text,
              desc text,
              color int(10)
            )
          '''
        );
      } 
    );
  }

  static Future<void> insertToDb(String tableName, Map<String, Object> data) async {

    final database = await DBHelper.database(tableName);

    database.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String tableName) async {

    final database = await DBHelper.database(tableName);

    return await database.query(tableName);
  }
}
