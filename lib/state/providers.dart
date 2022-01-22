import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/services/db/platforms/database.dart';
import 'package:tagros_comptes/state/bloc/entry_db_bloc.dart';
import 'package:tagros_comptes/state/bloc/game_notifier.dart';

final databaseProvider = Provider<MyDatabase>((ref) {
  final db = MyDatabase(Database.openConnection());
  ref.onDispose(() {
    db.close();
  });
  return db;
});

final gameChangeProvider = Provider<GameNotifier>((ref) {
  final gameChange = GameNotifier(database: ref.watch(databaseProvider));
  ref.onDispose(() {
    gameChange.dispose();
  });
  return gameChange;
});

final gameProvider = Provider<GameWithPlayers>((ref) {
  throw StateError("no game selected");
});

final entriesProvider = Provider<EntriesDbBloc>((ref) {
  final entries = EntriesDbBloc(ref.watch(gameProvider),
      database: ref.watch(databaseProvider));
  ref.onDispose(() {
    entries.dispose();
  });
  return entries;
}, dependencies: [gameProvider, databaseProvider]);
