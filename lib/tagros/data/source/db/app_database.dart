import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:tagros_comptes/tagros/data/source/db/games_dao.dart';
import 'package:tagros_comptes/tagros/data/source/db/platforms/database.dart';
import 'package:tagros_comptes/tagros/data/source/db/players_dao.dart';
import 'package:tagros_comptes/theme/data/source/theme_dao.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';

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

class PlayerGames extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get player => integer().references(Players, #id)();

  IntColumn get game => integer().references(Games, #id)();
}

class Configs extends Table {
  TextColumn get key => text()();

  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName("ThemeDb")
class Themes extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  BoolColumn get preset => boolean().withDefault(const Constant(true))();

  IntColumn get accentColor =>
      integer().withDefault(const Constant(0xFF861313))();

  IntColumn get appBarColor =>
      integer().withDefault(const Constant(0xff393a3e))();

  IntColumn get buttonColor =>
      integer().withDefault(const Constant(0xff861313))();

  IntColumn get positiveEntryColor =>
      integer().withDefault(const Constant(0xff393a3e))();

  IntColumn get negativeEntryColor =>
      integer().withDefault(const Constant(0xff861313))();

  IntColumn get positiveSumColor =>
      integer().withDefault(const Constant(0xff246305))();

  IntColumn get negativeSumColor =>
      integer().withDefault(const Constant(0xff861313))();

  IntColumn get horizontalColor =>
      integer().withDefault(const Constant(0xff393a3e))();

  IntColumn get playerNameColor =>
      integer().withDefault(const Constant(0xff393a3e))();

  IntColumn get textColor =>
      integer().withDefault(const Constant(0xff292f38))();

  IntColumn get frameColor =>
      integer().withDefault(const Constant(0xff375161))();

  IntColumn get chipColor =>
      integer().withDefault(const Constant(0xff393a3e))();

  IntColumn get backgroundColor =>
      integer().withDefault(const Constant(0x00000000))();

  IntColumn get textButtonColor =>
      integer().withDefault(const Constant(0xffffffff))();

  IntColumn get appBarTextColor =>
      integer().withDefault(const Constant(0xffffffff))();

  RealColumn get appBarTextSize => real().withDefault(const Constant(19.0))();

  IntColumn get fabColor => integer().withDefault(const Constant(0xff861313))();

  IntColumn get onFabColor =>
      integer().withDefault(const Constant(0xffffffff))();

  IntColumn get sliderColor =>
      integer().withDefault(const Constant(0xff323747))();

  IntColumn get backgroundGradient1 =>
      integer().withDefault(const Constant(0xffeee9e4))();

  IntColumn get backgroundGradient2 =>
      integer().withDefault(const Constant(0xffe7e1d4))();
}

@DriftDatabase(
  tables: [Players, Games, InfoEntries, PlayerGames, Themes, Configs],
  daos: [PlayersDao, GamesDao, ThemeDao],
)
class AppDatabase extends _$AppDatabase {
  // We tell the database where to store the data with this constructor
  AppDatabase(super.conn);

  // Bump this number whenever we change or add a table definition
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
        onCreate: (Migrator m) => m.createAll(),
        onUpgrade: (Migrator m, int from, int to) async {
          // For example:
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          if (details.wasCreated) {
            // create themes and select default when opening the db for the 1st time
            await batch((batch) {
              batch.insertAll(
                  themes, ThemeColor.allThemes.map((e) => e.toDbTheme).toList(),
                  mode: InsertMode.insertOrReplace);
              batch.insert(
                configs,
                ConfigsCompanion(
                    key: const Value(ThemeDao.selectedKey),
                    value: Value(ThemeColor.defaultTheme().id.toString())),
              );
            });
          }
          // This follows the recommendation to validate that the database schema
          // matches what drift expects (https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime).
          // It allows catching bugs in the migration logic early.
          await Database.validateDatabaseScheme(this);

          // if we are debugging the database, we delete all tables and recreate them
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
