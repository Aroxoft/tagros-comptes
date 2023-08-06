import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/monetization/domain/subscribe.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';
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
    return SubscriptionState(
      isPro: false,
      isLoading: true,
      packages: _packages,
      error: null,
      temporaryError: null,
    );
  }

  Future<void> _loadPackages() async {
    if (await _subscriptionService.hasPro()) {
      state = state.copyWith(isPro: true, isLoading: false);
      return;
    }
    _clearErrorsAndLoading();
    final packages = await _subscriptionService.getPackages();
    switch (packages) {
      case FailurePurchase():
        state = state.copyWith(error: packages.error, isLoading: false);
      case SuccessPurchase<List<Package>>():
        _packages = packages.data;
        state = state.copyWith(packages: _packages, isLoading: false);
    }
  }

  Future<void> buy(Package package) async {
    _clearErrorsAndLoading();
    final purchase = await _subscriptionService.purchase(package);
    switch (purchase) {
      case FailurePurchase():
        state =
            state.copyWith(temporaryError: purchase.error, isLoading: false);
      case SuccessPurchase<CustomerInfo>():
        if (_subscriptionService.isPro(purchase.data)) {
          state = state.copyWith(isPro: true, isLoading: false);
        }
    }
  }

  Future<void> restorePurchase() async {
    _clearErrorsAndLoading();
    final restore = await _subscriptionService.restore();
    if (restore) {
      state = state.copyWith(isPro: true, isLoading: false);
    } else {
      state = state.copyWith(
          temporaryError: RestoreFailedError(), isLoading: false);
    }
  }

  void _clearErrorsAndLoading() {
    state = state.copyWith(
      error: null,
      temporaryError: null,
      isLoading: true,
    );
  }

  void clearAll() {
    state = state.copyWith(
      error: null,
      temporaryError: null,
      isLoading: false,
    );
  }
}
