import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagros_comptes/model/info_entry.dart';

class DBProvider {
  static const int DATABASE_VERSION = 1;

  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static final String entryTable = 'infoEntry';
  static final String gameTable = 'game';
  static final String playerTable = 'player';

  static final String id = 'id';

  // game fields
  static final String nbPlayers = 'nbPlayers';

  // Player fields
  static final String name = 'name';

  // infoEntry fields
  static final String player = 'player';
  static final String prise = 'prise';
  static final String points = 'points';
  static final String game = 'game';
  static final String nbBouts = 'nbBouts';

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    // Get the location of our app directory. This is where files for our app,
    // and only our app, are stored. Files in this directory are deleted
    // when the app is deleted.
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'app.db');

    return await openDatabase(path,
        version: DATABASE_VERSION,
        onOpen: (db) async {}, onCreate: (Database db, int version) async {
          // TODO create the game table
          await db.execute('''
          CREATE TABLE $gameTable(
            $id INTEGER PRIMARY KEY,
            $nbPlayers INTEGER
          )
          ''');

          await db.execute('''
          CREATE TABLE $playerTable(
            $id INTEGER PRIMARY KEY,
            $name TEXT NOT NULL
          )''');

          // Create the entry table
          await db.execute('''
          CREATE TABLE $entryTable(
            $id INTEGER PRIMARY KEY,
            $player TEXT NOT NULL,
            $prise TEXT NOT NULL,
            $points REAL,
            $game INTEGER,
            $nbBouts INTEGER
          )''');
    });
  }

  Future<int> newEntry(InfoEntry infoEntry) async {
    final db = await database;
    var res = await db.insert(entryTable, infoEntry.toJson());
    return res;
  }

  Future<List<InfoEntry>> getInfoEntries() async {
    final db = await database;
    var res = await db.query(entryTable);
    List<InfoEntry> entries = res.isNotEmpty
        ? res.map((entry) => InfoEntry.fromJson(entry)).toList()
        : [];
    return entries;
  }

  Future<InfoEntry> getEntry(int id) async {
    final db = await database;
    var res = await db.query(entryTable, where: '$id = ?', whereArgs: [id]);
    return res.isNotEmpty ? InfoEntry.fromJson(res.first) : null;
  }

  Future<int> updateEntry(InfoEntry entry) async {
    final db = await database;
    var res = await db.update(entryTable, entry.toJson(),
        where: 'id = ?', whereArgs: [entry.id]);
    return res;
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    var res = await db.delete(entryTable, where: '$id = ?', whereArgs: [id]);
    return res;
  }
}
