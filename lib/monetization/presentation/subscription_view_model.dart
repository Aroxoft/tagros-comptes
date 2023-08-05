import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/monetization/domain/subscribe.dart';
import 'package:tagros_comptes/monetization/presentation/subscription_state.dart';

part 'subscription_view_model.g.dart';

@riverpod
class SubscriptionViewModel extends _$SubscriptionViewModel {
  late final SubscriptionService _subscriptionService;

  SubscriptionViewModel();

  List<Package> _packages = [];

  @override
  SubscriptionState build() {
    _subscriptionService = ref.read(subscriptionServiceProvider.notifier);
    _loadPackages();
    return SubscriptionState.loading();
  }

  Future<void> _loadPackages() async {
    final packages = await _subscriptionService.getPackages();
    switch (packages) {
      case FailurePurchase():
        state = SubscriptionState.error(packages.error);
      case SuccessPurchase<List<Package>>():
        _packages = packages.data;
        state = SubscriptionState.offers(packages: _packages);
    }
  }

  Future<void> buy(Package package) async {
    final purchase = await _subscriptionService.purchase(package);
    switch (purchase) {
      case FailurePurchase():
        state = SubscriptionState.offers(
            packages: _packages, temporaryError: purchase.error);
      case SuccessPurchase<CustomerInfo>():
        if (_subscriptionService.isPro(purchase.data)) {
          state = SubscriptionState.pro();
        } else {
          state = SubscriptionState.offers(packages: _packages);
        }
    }
  }

  Future<void> restorePurchase() async {
    final restore = await _subscriptionService.restore();
    if (restore) {
      state = SubscriptionState.pro();
    } else {
      state = SubscriptionState.offers(
        packages: _packages,
        temporaryError: null,
      );
    }
  }
}
