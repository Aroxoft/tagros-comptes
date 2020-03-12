import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';

part 'database_moor.g.dart';

//@DataClassName("player")
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get pseudo => text()();
}

//@DataClassName("game")
class Games extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get nbPlayers => integer()();
  DateTimeColumn get date => dateTime()();
}

@DataClassName("InfoEntry")
class InfoEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get game => integer()();
  IntColumn get player => integer()();
  IntColumn get with1 => integer().nullable()();
  IntColumn get with2 => integer().nullable()();
  RealColumn get points => real()();
  BoolColumn get pointsForAttack => boolean().withDefault(Constant(true))();
  TextColumn get petitAuBout => text().nullable()();
  TextColumn get poignee => text().nullable()();
  TextColumn get prise => text()();
  IntColumn get nbBouts => integer()();
}

//@DataClassName("player_game")
class PlayerGames extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get player => integer()();
  IntColumn get game => integer()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // put the database file in the doc folder
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.parent.path, 'databases/app.db'));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Players, Games, InfoEntries, PlayerGames])
class MyDatabase extends _$MyDatabase {
  static const int DATABASE_VERSION = 1;

  // We tell the database where to store the data with this constructor
  MyDatabase._() : super(_openConnection());

  // Bump this number whenever we change or add a table definition
  @override
  int get schemaVersion => DATABASE_VERSION;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
        onCreate: (Migrator m) => m.createAll(),
        onUpgrade: (Migrator m, int from, int to) async {
          // For example:
//      if(from == 1) {
//        await m.addColumn(players, players.pseudo)
//      }
        },
        beforeOpen: (details) async {
          // TODO
        });
  }

  static final MyDatabase db = MyDatabase._();

  // <editor-fold desc="GET">
  // loads all entries
  Future<List<InfoEntry>> get allInfoEntries => select(infoEntries).get();

  Stream<List<InfoEntryPlayerBean>> get watchInfoEntries {
    final with1 = alias(players, 'w1');
    final with2 = alias(players, 'w2');
    final p = alias(players, 'p');
    final query = select(infoEntries).join([
      leftOuterJoin(p, p.id.equalsExp(infoEntries.player)),
      leftOuterJoin(with1, with1.id.equalsExp(infoEntries.with1)),
      leftOuterJoin(with2, with2.id.equalsExp(infoEntries.with2))
    ]);
    return query.watch().map((rows) {
      return rows.map((row) {
        return InfoEntryPlayerBean(
          player: PlayerBean.fromDb(row.readTable(p)),
          withPlayers: [
            PlayerBean.fromDb(row.readTable(with1)),
            PlayerBean.fromDb(row.readTable(with2))
          ].where((element) => element != null).toList(),
          infoEntry: InfoEntryBean.fromDb(row.readTable(infoEntries)),
        );
      }).toList();
    });
  }

  Stream<List<InfoEntryPlayerBean>> watchInfoEntriesInGame(int gameId) {
    final with1 = alias(players, 'w1');
    final with2 = alias(players, 'w2');
    final p = alias(players, 'p');
    final query =
        (select(infoEntries)..where((tbl) => tbl.game.equals(gameId))).join([
      leftOuterJoin(p, p.id.equalsExp(infoEntries.player)),
      leftOuterJoin(with1, with1.id.equalsExp(infoEntries.with1)),
      leftOuterJoin(with2, with2.id.equalsExp(infoEntries.with2))
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return InfoEntryPlayerBean(
            player: PlayerBean.fromDb(row.readTable(p)),
            withPlayers: [
              PlayerBean.fromDb(row.readTable(with1)),
              PlayerBean.fromDb(row.readTable(with2))
            ].where((element) => element != null).toList(),
            infoEntry: InfoEntryBean.fromDb(row.readTable(infoEntries)));
      }).toList();
    });
  }

  Future<List<InfoEntry>> allInfoEntriesInGame(int idGame) =>
      (select(infoEntries)..where((tbl) => infoEntries.game.equals(idGame)))
          .get();

  Stream<List<Player>> get watchAllPlayers => select(players).watch();
  Future<List<Player>> get allPlayers => select(players).get();

  Stream<List<Player>> watchPlayersStarting(String start) {
    // TODO
    throw "e";
//    return (select(players)..where((tbl) => infoEntries.pseudo.equals(start))).watch();
  }

  //</editor-fold>

  //<editor-fold desc="INSERT">

  Future<int> newEntry(
      InfoEntryPlayerBean infoEntry, GameWithPlayers game) async {
    Value<int> with1 = Value.absent(), with2 = Value.absent();
    if (infoEntry.withPlayers != null && infoEntry.withPlayers.isNotEmpty) {
      with1 = Value(infoEntry.withPlayers[0].id);
      if (infoEntry.withPlayers.length > 1) {
        with2 = Value(infoEntry.withPlayers[1].id);
      }
    }
    return into(infoEntries).insert(InfoEntriesCompanion.insert(
      game: game.id,
      player: infoEntry.player.id,
      points: infoEntry.infoEntry.points,
      prise: toDbPrise(infoEntry.infoEntry.prise),
      nbBouts: infoEntry.infoEntry.nbBouts,
      pointsForAttack: Value(infoEntry.infoEntry.pointsForAttack),
      petitAuBout: Value(toDbPetits(infoEntry.infoEntry.petitsAuBout)),
      poignee: Value(toDbPoignees(infoEntry.infoEntry.poignees)),
      with1: with1,
      with2: with2,
    ));
  }

  Future<int> newGame(GameWithPlayers gameWithPlayers) {
    return transaction(() async {
      final Game game = gameWithPlayers.toGameDb();

      var idGame =
          await into(games).insert(game, mode: InsertMode.insertOrReplace);

      var idPlayers = await addPlayers(gameWithPlayers.players
          .map((e) => PlayersCompanion.insert(pseudo: e.pseudo)));

      batch((batch) => batch.insertAll(playerGames, [
            for (var idPlayer in idPlayers)
              PlayerGamesCompanion(game: Value(idGame), player: Value(idPlayer))
          ]));

      return idGame;
    });
  }

  Future<List<int>> addPlayers(Iterable<PlayersCompanion> thePlayers) async {
    List<int> playersIds = [];
    for (var player in thePlayers) {
      var single = await (select(players)
            ..where((tbl) => players.pseudo.equals(player.pseudo.value)))
          .getSingle();
      if (single == null) {
        var id = await newPlayer(playersCompanion: player);
        playersIds.add(id);
      } else {
        playersIds.add(single.id);
      }
    }
    return playersIds;
  }

  Future<int> newPlayer({Player player, PlayersCompanion playersCompanion}) {
    assert(player != null ||
        playersCompanion != null &&
            (player == null || playersCompanion == null));
    if (player != null)
      return into(players)
          .insert(PlayersCompanion.insert(pseudo: player.pseudo));
    return into(players).insert(playersCompanion);
  }
  //</editor-fold>

  //<editor-fold desc="UPDATE">
  Future<int> updateEntry(InfoEntryPlayerBean infoEntry) async {
    Value<int> with1 = Value.absent(), with2 = Value.absent();
    if (infoEntry.withPlayers != null && infoEntry.withPlayers.isNotEmpty) {
      with1 = Value(infoEntry.withPlayers[0].id);
      if (infoEntry.withPlayers.length > 1) {
        with2 = Value(infoEntry.withPlayers[1].id);
      }
    }

    return (update(infoEntries)
          ..where((tbl) => tbl.id.equals(infoEntry.infoEntry.id)))
        .write(InfoEntriesCompanion(
      player: Value(infoEntry.player.id),
      points: Value(infoEntry.infoEntry.points),
      prise: Value(toDbPrise(infoEntry.infoEntry.prise)),
      nbBouts: Value(infoEntry.infoEntry.nbBouts),
      pointsForAttack: Value(infoEntry.infoEntry.pointsForAttack),
      petitAuBout: Value(toDbPetits(infoEntry.infoEntry.petitsAuBout)),
      poignee: Value(toDbPoignees(infoEntry.infoEntry.poignees)),
      with1: with1,
      with2: with2,
    ));
  }

  //</editor-fold>

  //<editor-fold desc="DELETE">
  Future<int> deleteEntry(int entryId) async {
    return (delete(infoEntries)..where((tbl) => tbl.id.equals(entryId))).go();
  }

  //</editor-fold>
}
