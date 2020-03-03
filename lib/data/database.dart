import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tagros_comptes/model/game.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/player.dart';

class DBProvider {
  static const int DATABASE_VERSION = 1;

  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static final String entryTable = 'infoEntry';
  static final String gameTable = 'game';
  static final String playerTable = 'player';
  static final String playerGameTable = 'playerGame';

  static final String id = 'id';

  // game fields
  static final String nbPlayers = 'nbPlayers';
  static final String dateTime = 'dateTime';

  // Player fields
  static final String name = 'name';

  // infoEntry fields
  static final String player = 'player';
  static final String prise = 'prise';
  static final String points = 'points';
  static final String game = 'game';
  static final String nbBouts = 'nbBouts';
  static final String petitAuBout = 'petitAuBout';
  static final String poignee = 'poignee';
  static final String with1 = 'with1';
  static final String with2 = 'with2';

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
        onOpen: (db) async {},
        onCreate: (Database db, int version) async {
          // TODO create the game table
          await db.execute('''
          CREATE TABLE $gameTable(
            $id INTEGER PRIMARY KEY,
            $nbPlayers INTEGER,
            $dateTime INTEGER
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
            $game INTEGER,
            $player INTEGER NOT NULL,
            $with1 INTEGER,
            $with2 INTEGER,
            $points REAL,
            $petitAuBout TEXT,
            $poignee TEXT,
            $prise TEXT NOT NULL,
            $nbBouts INTEGER,
            FOREIGN KEY ($game) REFERENCES $gameTable ($id) ON DELETE CASCADE,
            FOREIGN KEY ($player) REFERENCES $playerTable ($id) ON DELETE CASCADE,
            FOREIGN KEY ($with1) REFERENCES $playerTable ($id) ON DELETE CASCADE,
            FOREIGN KEY ($with2) REFERENCES $playerTable ($id) ON DELETE CASCADE
          )''');

          // Create the association table playerGame
          await db.execute('''
          CREATE TABLE $playerGameTable(
            $id INTEGER PRIMARY KEY AUTOINCREMENT,
            $player INTEGER,
            $game INTEGER,
            FOREIGN KEY ($player) REFERENCES $playerTable ($id) ON DELETE CASCADE,
            FOREIGN KEY ($game) REFERENCES $gameTable ($id) ON DELETE CASCADE
          )''');
    });
  }

  Future<int> newEntry(InfoEntry infoEntry, Game game) async {
    final db = await database;
    var res = await db.insert(entryTable, infoEntry.toJson(game),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<InfoEntry>> getInfoEntries(int idGame) async {
    if (idGame == null) {
      return Future.value([]);
    }
    final db = await database;
    var res = await db.query(entryTable, where: "$id = ?", whereArgs: [idGame]);
    List<Future<InfoEntry>> entries = res.isNotEmpty
        ? res.map((entry) => InfoEntry.fromJson(entry, this)).toList()
        : [];
    return Future.wait(entries);
  }

  Future<List<Player>> getPlayers({Database db}) async {
    if (db == null) db = await database;
    var res = await db.query(playerTable);
    List<Player> players = res.isNotEmpty ? res.map((e) => Player.fromJson(e,))
        .toList() : [];
    return players;
  }

  Future<int> newGame(Game game) async {
    final db = await database;
    var res = await db.insert(
        gameTable, game.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    // Update game with ID
    game.id = res;

    addPlayers(game.players, db: db);
    return res;
  }


  Future<int> newPlayer(Player player, {Database db}) async {
    if (db == null) db = await database;
    var res = await db.insert(playerTable, player.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // Update player with ID
    player.id = res;
    return res;
  }

  addPlayers(List<Player> players, {Database db}) async {
    if (db == null) db = await database;
    for (var player in players) {
      var query = await db.query(
          playerTable, where: "$name = ?", whereArgs: [player.name]);
      if (query.isNotEmpty) {
        player = Player.fromJson(query.first);
      } else {
        await newPlayer(player, db: db);
      }
    }
  }

  Future<InfoEntry> getEntry(int entryId) async {
    final db = await database;
    var res = await db.query(
        entryTable, where: '$id = ?', whereArgs: [entryId]);
    return res.isNotEmpty ? InfoEntry.fromJson(res.first, this) : null;
  }

  Future<int> updateEntry(InfoEntry entry, Game game) async {
    final db = await database;
    var res = await db.update(entryTable, entry.toJson(game),
        where: 'id = ?', whereArgs: [entry.id]);
    return res;
  }

  Future<int> deleteEntry(int entryId) async {
    final db = await database;
    var res = await db.delete(
        entryTable, where: '$id = ?', whereArgs: [entryId]);
    return res;
  }

  Future<Player> getPlayer(int playerId) async {
    if(playerId == null) {
      return Future.value(null);
    }
    final db = await database;
    var res = await db.query(
        playerTable, where: '$id = ?', whereArgs: [playerId]);
    return res.isNotEmpty ? Player.fromJson(res.first) : null;
  }

}
