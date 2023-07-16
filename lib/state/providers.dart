import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/.env.dart';
import 'package:tagros_comptes/config/env_configuration.dart';
import 'package:tagros_comptes/config/platform_configuration.dart';
import 'package:tagros_comptes/state/viewmodel/choose_player_view_model.dart';
import 'package:tagros_comptes/state/viewmodel/clean_players_view_model.dart';
import 'package:tagros_comptes/state/viewmodel/theme_screen_viewmodel.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/games_dao.dart';
import 'package:tagros_comptes/tagros/data/source/db/platforms/database.dart';
import 'package:tagros_comptes/tagros/data/source/db/players_dao.dart';
import 'package:tagros_comptes/tagros/domain/ads_calculator.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/theme/data/theme_repository_impl.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_repository.dart';
import 'package:tuple/tuple.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true, dependencies: [])
AppDatabase database(DatabaseRef ref) {
  final db = AppDatabase(Database.openConnection());
  ref.onDispose(() {
    db.close();
  });
  return db;
}

@Riverpod(keepAlive: true, dependencies: [database])
PlayersDao playerDao(PlayerDaoRef ref) {
  return ref.watch(databaseProvider.select((value) => value.playersDao));
}

@Riverpod(keepAlive: true, dependencies: [database])
GamesDao gamesDao(GamesDaoRef ref) {
  return ref.watch(databaseProvider.select((value) => value.gamesDao));
}

final cleanPlayerProvider = ChangeNotifierProvider<CleanPlayersVM>((ref) {
  return CleanPlayersVM(ref.watch(playerDaoProvider));
});

final choosePlayerProvider =
    ChangeNotifierProvider.autoDispose<ChoosePlayerVM>((ref) {
  return ChoosePlayerVM(ref.watch(playerDaoProvider));
});

@Riverpod(keepAlive: true, dependencies: [database])
ThemeRepository themeRepository(ThemeRepositoryRef ref) =>
    ThemeRepositoryImpl(ref.watch(databaseProvider).themeDao);

@Riverpod(dependencies: [themeRepository])
Stream<ThemeData> themeData(ThemeDataRef ref) {
  return ref.watch(themeRepositoryProvider.select((value) => value.themeData));
}

@Riverpod(dependencies: [themeRepository])
Stream<ThemeColor> themeColor(ThemeColorRef ref) =>
    ref.watch(themeRepositoryProvider.select((value) => value.selectedTheme()));

final themeViewModelProvider = ChangeNotifierProvider<ThemeScreenViewModel>(
    (ref) => ThemeScreenViewModel(ref.watch(themeRepositoryProvider)));

final navigationPrefixProvider = Provider<String>((ref) => "");

final _platformConfigProvider = Provider<PlatformConfiguration>((ref) {
  return PlatformConfiguration();
});

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

/// This is sent whenever we add or modify an entry
///
/// - The first value is true if we added a new entry, false if we modified an existing one
/// - The second value is the entry we added or modified
final messageObserverProvider =
    StateProvider<Tuple2<bool, InfoEntryPlayerBean>?>((ref) {
  return null;
});
