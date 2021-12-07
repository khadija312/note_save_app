
import 'package:note_save_app/object/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _datatbase = null;
  DatabaseHelper._instance();
  String noteTable = 'note_Table';
  String colId = 'id';
  String colTitle = 'title';
  String colDate = 'date';
  String colPriority = 'priority';
  String colStatus = 'status';
  Future<Database?> get database async{
    if(_datatbase == null){
      _datatbase = await initDb();
    }
    return _datatbase;
  }
Future<Database> initDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note_list.db';
    final notelistDB = await openDatabase(path, version:  1, onCreate: _createDb);
    return notelistDB;
  }
  void _createDb(Database db, int version)async{
    await db.execute(
      'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER)'
    );
  }

  Future<List<Map<String,dynamic>>> getNoteMapList() async{
    Database? database = await this.database;
    final List<Map<String,dynamic>> result = await database!.query(noteTable);
    return result;
  }
  Future<List<Note>> getNoteList()async{
    final List<Map<String,dynamic>> noteMapList = await getNoteMapList();
    final List<Note> noteList = [];
    noteMapList.forEach((noteMap) {
      noteList.add(Note.fromMap(noteMap));
    });
    noteList.sort((noteA,noteB)=>noteA.date!.compareTo(noteB.date!));
    return noteList;
  }
  Future<int> insertNote(Note note)async{
    Database? db = await this.database;
    final int result = await db!.insert(
      noteTable,
      note.toMap(),
    );
    return result;
  }
  Future<int> updateNote(Note note)async{
    Database? database = await this.database;
    final int result = await database!.update(
        noteTable,
        note.toMap(),
        where: '$colId = ?',
        whereArgs: [note.id]
    );
    return result;
  }
  Future<int> deleteNote(int id)async{
    Database? database = await this.database;
    final int result = await database!.delete(
        noteTable,
        where: '$colId = ?',
        whereArgs: [id]
    );
    return result;
  }

}