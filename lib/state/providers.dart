import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/.env.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/model/game/info_entry_player.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:tagros_comptes/navigation/router.dart';
import 'package:tagros_comptes/services/config/env_configuration.dart';
import 'package:tagros_comptes/services/config/platform_configuration.dart';
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
import 'package:tagros_comptes/ui/table_screen/ads_calculator.dart';

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

final selectedGameIdProvider = Provider<int?>((ref) {
  return null;
});
final selectedInfoEntryIdProvider = Provider<int?>((ref) {
  return null;
});

final currentGameProvider = FutureProvider<GameWithPlayers>((ref) {
  final gameId = ref.watch(selectedGameIdProvider);
  if (gameId == null) throw StateError("no game selected");
  return ref.watch(gamesDaoProvider).getGameWithPlayers(gameId);
}, dependencies: [selectedGameIdProvider]);

final currentPlayersProvider = FutureProvider((ref) async {
  final game = ref.watch(currentGameProvider).value;
  return game?.players;
}, dependencies: [currentGameProvider]);

final currentInfoEntryProvider = FutureProvider<InfoEntryPlayerBean?>((ref) {
  final entryId = ref.watch(selectedInfoEntryIdProvider);
  if (entryId == null) return null;
  return ref.watch(gamesDaoProvider).getInfoEntry(entryId);
}, dependencies: [selectedInfoEntryIdProvider]);
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

final entriesProvider = Provider<EntriesDbBloc?>((ref) {
  final currentGame = ref.watch(currentGameProvider).value;
  if (currentGame == null) return null;
  final entries =
      EntriesDbBloc(currentGame, gamesDao: ref.watch(gamesDaoProvider));
  ref.onDispose(() {
    entries.dispose();
  });
  return entries;
}, dependencies: [currentGameProvider, gamesDaoProvider]);

final navigationPrefixProvider = Provider<String>((ref) => "");

final _platformConfigProvider = Provider<PlatformConfiguration>((ref) {
  return PlatformConfiguration();
});
// region Navigation
final routerProvider = Provider<MyRouter>((ref) {
  return MyRouter();
});
// endregion

// region Ads
final adsCalculatorProvider = Provider<AdsCalculator>((ref) {
  return AdsCalculator();
});

final adsConfigurationProvider = Provider<AdsConfiguration>((ref) {
  return AdsConfiguration(environment, ref.watch(_platformConfigProvider));
});

final nativeAdIdProvider = Provider<String>((ref) {
  return ref.watch(adsConfigurationProvider.select((value) => value.nativeId));
});

final nativeAdProvider =
    FutureProvider.autoDispose.family<NativeAd, int>((ref, index) {
  final completer = Completer<NativeAd>();
  NativeAd(
    adUnitId:
        ref.watch(adsConfigurationProvider.select((value) => value.nativeId)),
    request: const AdRequest(),
    factoryId: 'listTile',
    listener: NativeAdListener(
      onAdLoaded: (Ad ad) {
        if (kDebugMode) {
          print('Native Ad loaded: $ad.');
        }
        completer.complete(ad as NativeAd);
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        ad.dispose();
        if (kDebugMode) {
          print('Ad failed to load: $error');
        }
        completer.completeError(error);
      },
    ),
  ).load();
  ref.onDispose(() {
    completer.future.then((value) => value.dispose());
  });
  return completer.future;
});

final bannerAdsProvider =
    FutureProvider.autoDispose.family<BannerAd, int>((ref, width) async {
  final completer = Completer<BannerAd>();
  final AnchoredAdaptiveBannerAdSize? size =
      await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
  if (size == null) {
    completer.completeError("size is null");
  } else {
    BannerAd(
      adUnitId:
          ref.watch(adsConfigurationProvider.select((value) => value.bannerId)),
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            print("Ad $ad loaded.");
          }
          completer.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          if (kDebugMode) {
            print("Ad $ad failed to load: $error");
          }
          ad.dispose();
          completer.completeError(error);
        },
      ),
    ).load();
  }
  ref.onDispose(() {
    completer.future.then((value) => value.dispose());
  });
  return completer.future;
});
// endregion
