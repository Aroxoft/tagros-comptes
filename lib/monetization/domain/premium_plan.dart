import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/monetization/data/subscription_repository.dart';

final isPremiumProvider = FutureProvider<bool>((ref) async {
  return ref.watch(
      subscriptionRepositoryProvider.selectAsync((value) => value.isPremium));
});

final showAdsProvider = Provider<ShowAds>((ref) {
  return ref
      .watch(subscriptionRepositoryProvider.select((value) => value.maybeWhen(
            data: (value) => value.isPremium ? ShowAds.hide : ShowAds.show,
            error: (error, stack) => ShowAds.error,
            orElse: () => ShowAds.show,
          )));
});

enum ShowAds { show, hide, error }
