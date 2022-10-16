import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
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
  AppDatabase(super.conn);

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

//<editor-fold desc="DELETE">

//</editor-fold>
}
