import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';

class MobileAdWidget extends HookConsumerWidget {
  const MobileAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool premium = ref.watch(isPremiumProvider);
    final ad = useState<BannerAd?>(null);
    useEffect(() {
      if (!premium) {
        ref.read(adsProvider.future).then((value) {
          ad.value = BannerAd(
              size: AdSize.fluid,
              adUnitId: value.bannerAdUnitId,
              listener: BannerAdListener(
                onAdLoaded: (ad) {
                  if (kDebugMode) {
                    print('banner ad loaded ${ad.adUnitId}');
                  }
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
              request: const AdRequest())
            ..load();
        });
      }
      return null;
    }, ['menu']);
    if (!premium) {
      return Semantics(
        label: S.of(context).semanticAdBanner,
        child: SizedBox(
          height: 50,
          child: ad.value == null ? const SizedBox() : AdWidget(ad: ad.value!),
        ),
      );
    }
    return const SizedBox();
  }
}
