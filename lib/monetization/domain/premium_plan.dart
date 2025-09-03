import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/monetization/data/subscription_repository.dart';

class IsPremium extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    return ref.watch(
        subscriptionRepositoryProvider.selectAsync((value) => value.isPremium));
  }
}

final isPremiumProvider = AsyncNotifierProvider<IsPremium, bool>(IsPremium.new);

final showAdsProvider = Provider<ShowAds>((ref) {
  return ref
      .watch(subscriptionRepositoryProvider.select((value) => value.maybeWhen(
            data: (value) => value.isPremium ? ShowAds.hide : ShowAds.show,
            error: (error, stack) => ShowAds.error,
            orElse: () => ShowAds.show,
          )));
});

enum ShowAds { show, hide, error }
