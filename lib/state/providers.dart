import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/services/db/games_dao.dart';
import 'package:tagros_comptes/services/db/platforms/database.dart';
import 'package:tagros_comptes/services/db/players_dao.dart';
import 'package:tagros_comptes/services/theme/theme_service.dart';
import 'package:tagros_comptes/state/bloc/entry_db_bloc.dart';
import 'package:tagros_comptes/state/bloc/game_notifier.dart';
import 'package:tagros_comptes/state/viewmodel/choose_player_view_model.dart';
import 'package:tagros_comptes/state/viewmodel/clean_players_view_model.dart';
import 'package:tagros_comptes/state/viewmodel/theme_screen_viewmodel.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(Database.openConnection());
  ref.onDispose(() {
    db.close();
  });
  return db;
});

final playerDaoProvider = Provider<PlayersDao>((ref) {
  return ref.watch(databaseProvider.select((value) => value.playersDao));
});
final gamesDaoProvider = Provider<GamesDao>((ref) {
  return ref.watch(databaseProvider.select((value) => value.gamesDao));
});

final cleanPlayerProvider = ChangeNotifierProvider<CleanPlayersVM>((ref) {
  return CleanPlayersVM(ref.watch(playerDaoProvider));
});

final choosePlayerProvider =
    ChangeNotifierProvider.autoDispose<ChoosePlayerVM>((ref) {
  return ChoosePlayerVM(ref.watch(playerDaoProvider));
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

// final optionsProvider = StateProvider<ThemeColor>((ref) {
//   return ThemeColor();
// });

final themeProvider = Provider<ThemeService>((ref) {
  final themeService = ThemeService();
  ref.onDispose(() {
    themeService.dispose();
  });
  return themeService;
});
final themeDataProvider = StreamProvider<ThemeData>(
    (ref) => ref.watch(themeProvider.select((value) => value.themeData)),
    dependencies: [themeProvider]);

final themeColorProvider = StreamProvider<ThemeColor>(
    (ref) => ref.watch(themeProvider.select((value) => value.themeStream)),
    dependencies: [themeProvider]);

final themeViewModelProvider = ChangeNotifierProvider<ThemeScreenViewModel>(
    (ref) => ThemeScreenViewModel(ref.watch(themeProvider)));

final entriesProvider = Provider<EntriesDbBloc>((ref) {
  final entries = EntriesDbBloc(ref.watch(gameProvider),
      database: ref.watch(databaseProvider));
  ref.onDispose(() {
    entries.dispose();
  });
  return entries;
}, dependencies: [gameProvider, databaseProvider]);

final navigationPrefixProvider = Provider<String>((ref) => "");
