import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/.env.dart';
import 'package:tagros_comptes/config/env_configuration.dart';
import 'package:tagros_comptes/config/platform_configuration.dart';
import 'package:tagros_comptes/tagros/domain/ads_calculator.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tuple/tuple.dart';

part 'providers.g.dart';

@Riverpod(dependencies: [])
String navigationPrefix(NavigationPrefixRef ref) => "";

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
