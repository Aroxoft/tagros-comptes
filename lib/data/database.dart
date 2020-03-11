import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/data/database_moor.dart';

class DBProvider {
  /*
  static const int DATABASE_VERSION = 1;

  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static final String entryTable = 'infoEntry';
  static final String gameTable = 'game';
  static final String playerTable = 'player';
  static final String playerGameTable = 'playerGame';

  static final String idField = 'id';

  // game fields
  static final String nbPlayersField = 'nbPlayers';
  static final String dateTimeField = 'dateTime';

  // Player fields
  static final String nameField = 'name';

  // infoEntry fields
  static final String playerField = 'player';
  static final String priseField = 'prise';
  static final String pointsField = 'points';
  static final String gameField = 'game';
  static final String nbBoutsField = 'nbBouts';
  static final String petitAuBoutField = 'petitAuBout';
  static final String poigneeField = 'poignee';
  static final String with1Field = 'with1';
  static final String with2Field = 'with2';

  Db _database;

  Future<Db> get database async {
    if (_database != null) {
      return _database;
    }
    _database = Db();

    return _database;
  }

  initDB({@required Db db}) async {
    // Get the location of our app directory. This is where files for our app,
    // and only our app, are stored. Files in this directory are deleted
    // when the app is deleted.
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.parent.path, 'databases/app.db');

    final game = DbTable(gameTable)
      ..integer(idField, unique: true)
      ..integer(nbPlayersField)
      ..integer(dateTimeField);

    final player = DbTable(playerTable)
      ..integer(idField, unique: true)
      ..varchar(nameField, nullable: false)
      ..index(nameField);

    final entry = DbTable(entryTable)
      ..integer(idField, unique: true)
      ..integer(gameField, nullable: false)
      ..integer(playerField, nullable: false)
      ..integer(with1Field)
      ..integer(with2Field)
      ..real(pointsField)
      ..text(petitAuBoutField)
      ..text(poigneeField)
      ..text(priseField, nullable: false)
      ..integer(nbBoutsField, nullable: false)
      ..foreignKey(gameField, reference: gameTable, onDelete: OnDelete.cascade)
      ..foreignKey(playerField,
          reference: playerTable, onDelete: OnDelete.cascade)
      ..foreignKey(with1Field,
          reference: playerTable, onDelete: OnDelete.cascade)
      ..foreignKey(with2Field,
          reference: playerTable, onDelete: OnDelete.cascade);

    final playerGame = DbTable(playerGameTable)
      ..integer(idField, unique: true)
      ..integer(playerField, nullable: false)
      ..integer(gameField, nullable: false)
      ..foreignKey(playerField,
          reference: playerTable, onDelete: OnDelete.cascade)
      ..foreignKey(gameField, reference: gameTable, onDelete: OnDelete.cascade);

    await db.init(path: path, schema: [game, player, entry, playerGame]);
    db.schema.describe();
  }

  Future<int> newEntry(InfoEntry infoEntry, GameWithPlayers game) async {
    final db = await database;
    var res = await db.insert(table: entryTable, row: infoEntry.toJson(game));
    return res;
  }

  Future<List<InfoEntry>> getInfoEntries(int idGame) async {
    if (idGame == null) {
      return Future.value([]);
    }
    final db = await database;
    var res = await db.select(table: entryTable, where: "$idField = $idGame");
    List<Future<InfoEntry>> entries = res.isNotEmpty
        ? res.map((entry) => InfoEntry.fromJson(entry, this)).toList()
        : [];
    return Future.wait(entries);
  }

  Future<List<Player>> getPlayers({Db db}) async {
    if (db == null) db = await database;
    List<Map<String, dynamic>> res = await db.select(table: playerTable);
    List<Player> players = res.isNotEmpty
        ? res
            .map((e) => Player.fromJson(
                  e,
                ))
            .toList()
        : [];
    return players;
  }

  Stream<List<Player>> getPlayersStream({Db db}) {
    // TODO Fix me how to get stream from database
  }

  Future<int> newGame(GameWithPlayers game) async {
    final db = await database;
    var res = await db.insert(table: gameTable, row: game.toJson());
    // Update game with ID
    game.id = res;

    var players = await addPlayers(game.players, db: db);
    for (var playerId in players) {
      addPlayerGame(playerId: playerId, gameId: res);
    }

    return res;
  }

  Future<int> newPlayer(Player player, {Db db}) async {
    if (db == null) db = await database;
    var res = await db.insert(table: playerTable, row: player.toJson());
    // Update player with ID
    player.id = res;
    return res;
  }

  Future<List<int>> addPlayers(List<Player> players, {Db db}) async {
    if (db == null) db = await database;
    List<int> playerIds = [];
    for (var player in players) {
      var query = await db.select(
          table: playerTable, where: "$nameField = ${player.name}");
      if (query.isNotEmpty) {
        player = Player.fromJson(query.first);
      } else {
        await newPlayer(player, db: db);
      }
      playerIds.add(player.id);
    }
    return playerIds;
  }

  Future<InfoEntry> getEntry(int entryId) async {
    final db = await database;
    var res = await db.select(table: entryTable, where: '$idField = $entryId');
    return res.isNotEmpty ? InfoEntry.fromJson(res.first, this) : null;
  }

  Future<int> updateEntry(InfoEntry entry, GameWithPlayers game) async {
    final db = await database;
    var res = await db.update(
        where: 'id = ${entry.id}', row: entry.toJson(game), table: entryTable);
    return res;
  }

  Future<int> deleteEntry(int entryId) async {
    final db = await database;
    var res = await db.delete(where: '$idField = $entryId', table: entryTable);
    return res;
  }

  Future<Player> getPlayer(int playerId) async {
    if (playerId == null) {
      return Future.value(null);
    }
    final db = await database;
    var res =
        await db.select(where: '$idField = $playerId', table: playerTable);
    return res.isNotEmpty ? Player.fromJson(res.first) : null;
  }

  void addPlayerGame({@required int playerId, @required int gameId}) async {
    // TODO
    final db = await database;
    await db.insert(
        table: playerGameTable,
        row: {"player": playerId.toString(), "game": gameId.toString()});
  }
  // */
}
