import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/model/monetization/ad_state.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/services/db/games_dao.dart';
import 'package:tagros_comptes/services/db/platforms/database.dart';
import 'package:tagros_comptes/services/db/players_dao.dart';
import 'package:tagros_comptes/services/monetization/ad_service.dart';
import 'package:tagros_comptes/services/monetization/premium_service.dart';
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
  final gameChange = GameNotifier(gamesDao: ref.watch(gamesDaoProvider));
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
final adsProvider = FutureProvider<AdState>((ref) async {
  final adState = AdState.construct();
  MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
      testDeviceIds: [
        "43479C551F2DB09A212F4C5BE53E43FF",
        "D6E91F96B63685008A6A496200C1B7CB",
        "GADSimulatorID",
      ]));
  await adState.initialization;
  return adState;
});
final adServiceProvider = FutureProvider<AdService>((ref) async {
  final adState = await ref.watch(adsProvider.future);
  return AdService(adState,
      themeColor:
          ref.watch(themeColorProvider.select((value) => value.maybeWhen(
                data: (data) => data,
                orElse: () => ThemeColor.defaultTheme(),
              ))));
});
final premiumProvider =
    StateNotifierProvider<PremiumService, bool>((ref) => PremiumService());
final isPremiumProvider =
    Provider((ref) => ref.watch(premiumProvider.select((value) => value)));

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
  final entries = EntriesDbBloc(
    ref.watch(gameProvider),
    gamesDao: ref.watch(gamesDaoProvider),
    adService: ref.watch(adServiceProvider.future),
    isPremium: ref.watch(isPremiumProvider),
  );
  ref.onDispose(() {
    entries.dispose();
  });
  return entries;
}, dependencies: [
  gameProvider,
  gamesDaoProvider,
  isPremiumProvider,
]);

final navigationPrefixProvider = Provider<String>((ref) => "");
