import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/games_dao.dart';
import 'package:tagros_comptes/tagros/data/source/db/platforms/database.dart';
import 'package:tagros_comptes/tagros/data/source/db/players_dao.dart';

part 'db_providers.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
AppDatabase database(Ref ref) {
  final db = AppDatabase(Database.connect());
  ref.onDispose(() {
    db.close();
  });
  return db;
}

@Riverpod(keepAlive: true, dependencies: [database])
PlayersDao playerDao(Ref ref) {
  return ref.watch(databaseProvider.select((value) => value.playersDao));
}

@Riverpod(keepAlive: true, dependencies: [database])
GamesDao gamesDao(Ref ref) {
  return ref.watch(databaseProvider.select((value) => value.gamesDao));
}
