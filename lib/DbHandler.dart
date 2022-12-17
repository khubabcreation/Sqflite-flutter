import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'NotesModel.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
      documentDirectory.path,
      'notes.db',
    );
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT ,title TEXT NOT NULL,age INTEGER NOT NULL, email TEXT,description TEXT)",
    );
  }

  Future<NotesModel> insert(NotesModel model) async {
    var dbClient = await db;
    await dbClient!.insert('notes', model.tomap());
    return model;
  }

  Future<List<NotesModel>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> querryResult =
        await dbClient!.query('notes');
    return querryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'notes',
      where: 'id= ?',
      whereArgs: [id],
    );

  }
  Future<int> update(NotesModel model) async {
    var dbClient = await db;
    return await dbClient!.update(
      'notes',
      model.tomap(),
      where: 'id=?',
      whereArgs: [model.id],

    );
  }
}
