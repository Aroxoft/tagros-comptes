import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:tagros_comptes/model/game/camp.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/model/game/info_entry_player.dart';
import 'package:tagros_comptes/model/game/poignee.dart';
import 'package:tagros_comptes/model/game/prise.dart';
import 'package:tagros_comptes/services/db/games_dao.dart';
import 'package:tagros_comptes/services/db/players_dao.dart';

part 'app_database.g.dart';

const bool kDebuggingDatabase = false;

class Players extends Table {
  IntColumn get id => integer().autoIncrement().nullable()();

  TextColumn get pseudo => text()();
}

class Games extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get nbPlayers => integer()();

  DateTimeColumn get date => dateTime()();
}

@DataClassName("InfoEntry")
class InfoEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get game => integer().references(Games, #id)();

  IntColumn get player => integer().references(Players, #id)();

  IntColumn get with1 => integer().nullable().references(Players, #id)();

  IntColumn get with2 => integer().nullable().references(Players, #id)();

  RealColumn get points => real()();

  BoolColumn get pointsForAttack =>
      boolean().withDefault(const Constant(true))();

  TextColumn get petitAuBout => text().nullable()();

  TextColumn get poignee => text().nullable()();

  TextColumn get prise => text()();

  IntColumn get nbBouts => integer()();
}

//@DataClassName("player_game")
class PlayerGames extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get player => integer().references(Players, #id)();

  IntColumn get game => integer().references(Games, #id)();
}

@DriftDatabase(
  tables: [Players, Games, InfoEntries, PlayerGames],
  daos: [PlayersDao, GamesDao],
)
class AppDatabase extends _$AppDatabase {
  static const int databaseVersion = 1;

  // We tell the database where to store the data with this constructor
  AppDatabase(QueryExecutor conn) : super(conn);

  // Bump this number whenever we change or add a table definition
  @override
  int get schemaVersion => databaseVersion;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
        onCreate: (Migrator m) => m.createAll(),
        onUpgrade: (Migrator m, int from, int to) async {
          // For example:
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          if (kDebugMode && kDebuggingDatabase) {
            final m = Migrator(this);
            for (final table in allTables) {
              await m.deleteTable(table.actualTableName);
              await m.createTable(table);
            }
          }
        });
  }

  // <editor-fold desc="GET">

  Stream<List<Player>> get watchAllPlayers => select(players).watch();

  Future<List<Player>> get allPlayers => select(players).get();

  //</editor-fold>

  //<editor-fold desc="INSERT">

  Future<int> newEntry(
      InfoEntryPlayerBean infoEntry, GameWithPlayers game) async {
    Value<int> with1 = const Value.absent();
    Value<int> with2 = const Value.absent();
    if (infoEntry.withPlayers != null && infoEntry.withPlayers!.isNotEmpty) {
      with1 = Value(infoEntry.withPlayers![0]!.id!);
      if (infoEntry.withPlayers!.length > 1) {
        with2 = Value(infoEntry.withPlayers![1]!.id!);
      }
    }
    return into(infoEntries).insert(InfoEntriesCompanion.insert(
      game: game.game.id.value,
      player: infoEntry.player!.id!,
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
      final GamesCompanion game = gameWithPlayers.game;

      final idGame =
          await into(games).insert(game, mode: InsertMode.insertOrReplace);

      final idPlayers = await addPlayers(gameWithPlayers.players
          .map((e) => PlayersCompanion.insert(pseudo: e.pseudo)));

      final playersToInsert = idPlayers.map(
          (e) => PlayerGamesCompanion(game: Value(idGame), player: Value(e)));
      await batch((batch) => batch.insertAll(playerGames, playersToInsert));

      return idGame;
    });
  }

  Future<List<int>> addPlayers(Iterable<PlayersCompanion> thePlayers) async {
    final List<int> playersIds = [];
    for (final player in thePlayers) {
      final single = await (select(players)
            ..where((tbl) => players.pseudo.equals(player.pseudo.value)))
          .getSingleOrNull();
      if (single == null) {
        final id = await newPlayer(playersCompanion: player);
        playersIds.add(id);
      } else {
        playersIds.add(single.id!);
      }
    }
    return playersIds;
  }

  Future<int> newPlayer({Player? player, PlayersCompanion? playersCompanion}) {
    assert(player != null || playersCompanion != null && player == null);
    if (player != null) {
      return into(players)
          .insert(PlayersCompanion.insert(pseudo: player.pseudo));
    }
    return into(players).insert(playersCompanion!);
  }

  //</editor-fold>

  //<editor-fold desc="UPDATE">
  Future<int> updateEntry(InfoEntryPlayerBean infoEntry) async {
    Value<int> with1 = const Value.absent();
    Value<int> with2 = const Value.absent();
    if (infoEntry.withPlayers != null && infoEntry.withPlayers!.isNotEmpty) {
      with1 = Value(infoEntry.withPlayers![0]!.id!);
      if (infoEntry.withPlayers!.length > 1) {
        with2 = Value(infoEntry.withPlayers![1]!.id!);
      }
    }

    return (update(infoEntries)
          ..where((tbl) => tbl.id.equals(infoEntry.infoEntry.id)))
        .write(InfoEntriesCompanion(
      player: Value(infoEntry.player!.id!),
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

  Future<void> deleteGame(GameWithPlayers gameWithPlayers) async {
    return transaction(() async {
      await (delete(infoEntries)
            ..where((tbl) => tbl.game.equals(gameWithPlayers.game.id.value)))
          .go();
      await (delete(playerGames)
            ..where((tbl) => tbl.game.equals(gameWithPlayers.game.id.value)))
          .go();
      await (delete(games)
            ..where((tbl) => tbl.id.equals(gameWithPlayers.game.id.value)))
          .go();
    });
  }
//</editor-fold>
}
