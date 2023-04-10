import 'dart:async';

import 'package:admob_consent/admob_consent.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tagros_comptes/model/monetization/ad_state.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:universal_platform/universal_platform.dart';

class AdService {
  final List<Future<AdWithView>> _ads;
  final ThemeColor _themeColor;
  final AdState adState;
  final AdmobConsent _admobConsent;

  AdService(this.adState, {required ThemeColor themeColor})
      : _ads = [],
        _themeColor = themeColor,
        _admobConsent = AdmobConsent() {
    updateConsent();
  }

  List<Future<AdWithView>> get ads => UnmodifiableListView(_ads);

  Future<void> updateConsent() async {
    _admobConsent.show();
    _admobConsent.onConsentFormObtained.listen((event) {
      if (kDebugMode) {
        print("consent obtained");
      }
    });
  }

  void fetchAds({required int number}) {
    for (var i = _ads.length; i < number; i++) {
      final Completer<void> completer = Completer();
      AdWithView adWithView;
      if (UniversalPlatform.isAndroid) {
        adWithView = NativeAd(
            adUnitId: adState.nativeAdUnitId,
            customOptions: {
              "background":
                  "#${_themeColor.averageBackgroundColor.value.toRadixString(16)}",
              "textColor": "#${_themeColor.textColor.value.toRadixString(16)}",
            },
            factoryId: "myAdFactory",
            listener: NativeAdListener(
              onAdLoaded: (ad) {
                if (kDebugMode) {
                  print('loaded native ad ${ad.adUnitId}');
                }
                completer.complete();
              },
              onAdClicked: (ad) {
                if (kDebugMode) {
                  print('ad clicked: ${ad.adUnitId}');
                }
              },
              onAdClosed: (ad) {
                if (kDebugMode) {
                  print('native ad closed ${ad.adUnitId}');
                }
              },
              onAdOpened: (ad) {
                if (kDebugMode) {
                  print('native ad opened ${ad.adUnitId}');
                }
              },
              onAdFailedToLoad: (ad, error) {
                if (kDebugMode) {
                  print('native ad ${ad.adUnitId} failed to load ($error)');
                }
                completer.completeError(error);
                // Dispose the ad here to free resources
                ad.dispose();
              },
              onAdWillDismissScreen: (ad) {
                if (kDebugMode) {
                  print('native ad will dismiss screen ${ad.adUnitId}');
                }
              },
              onPaidEvent: (ad, valueMicros, precision, currencyCode) {
                if (kDebugMode) {
                  print(
                      'paid event native ad ${ad.adUnitId}, valueMicros: $valueMicros, precision $precision, currency $currencyCode');
                }
              },
              onAdImpression: (ad) {
                if (kDebugMode) {
                  print('native ad impression ${ad.adUnitId}');
                }
              },
            ),
            request: const AdRequest());
      } else {
        adWithView = BannerAd(
          size: AdSize.banner,
          adUnitId: adState.bannerAdUnitId,
          request: const AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              if (kDebugMode) {
                print('loaded banner ad ${ad.adUnitId}');
              }
              completer.complete();
            },
            onAdClosed: (ad) {
              if (kDebugMode) {
                print('banner ad closed ${ad.adUnitId}');
              }
            },
            onAdOpened: (ad) {
              if (kDebugMode) {
                print('banner ad opened ${ad.adUnitId}');
              }
            },
            onAdFailedToLoad: (ad, error) {
              if (kDebugMode) {
                print('banner ad ${ad.adUnitId} failed to load ($error)');
              }
              completer.completeError(error);
              // Dispose the ad here to free resources
              ad.dispose();
            },
            onAdWillDismissScreen: (ad) {
              if (kDebugMode) {
                print('banner ad will dismiss screen ${ad.adUnitId}');
              }
            },
            onPaidEvent: (ad, valueMicros, precision, currencyCode) {
              if (kDebugMode) {
                print(
                    'paid event banner ad ${ad.adUnitId}, valueMicros: $valueMicros, precision $precision, currency $currencyCode');
              }
            },
            onAdImpression: (ad) {
              if (kDebugMode) {
                print('banner ad impression ${ad.adUnitId}');
              }
            },
          ),
        );
      }
      adWithView.load();
      _ads.add(completer.future.then((value) => adWithView));
    }
  }
}
