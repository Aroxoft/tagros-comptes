import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/monetization/data/subscription_repository.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';
import 'package:tagros_comptes/monetization/presentation/error_mapper.dart';
import 'package:tagros_comptes/util/logger.dart';

part 'buy_view_model.freezed.dart';
part 'buy_view_model.g.dart';

@riverpod
class BuyViewModel extends _$BuyViewModel {
  late Logger _logger;

  @override
  AsyncValue<InfoBuyScreenState> build() {
    _logger = ref.watch(loggerProvider);
    _logger.log("BuyViewModel: re-building viewModel");
    return ref
        .watch(subscriptionRepositoryProvider.select((value) => value.whenData(
              (data) {
                return InfoBuyScreenState(
                  loadingAction: false,
                  errorAction: null,
                  isPremium: data.isPremium,
                  packages: data.packages,
                  selectedPackage: data.packages?.firstOrNull,
                );
              },
            )));
  }

  Future<void> restorePurchase() async {
    final buyState = state.value;
    if (buyState == null) return;
    state = AsyncData(buyState.copyWith(
      loadingAction: true,
      errorAction: null,
    ));
    final restorePurchase = await ref
        .read(subscriptionRepositoryProvider.notifier)
        .restorePurchase();
    switch (restorePurchase) {
      case final SuccessPurchase<CustomerInfo> success:
        state = AsyncData(buyState.copyWith(
          loadingAction: false,
          errorAction: null,
          isPremium:
              success.data.entitlements.active.containsKey(entitlementId),
        ));
      case final FailurePurchase f:
        state = AsyncData(buyState.copyWith(
          loadingAction: false,
          errorAction: f.error.message,
        ));
    }
  }

  Future<void> buy(Package package) async {
    final buyState = state.value;
    if (buyState == null) return;
    final purchaseResult =
        await ref.read(subscriptionRepositoryProvider.notifier).buy(package);
    switch (purchaseResult) {
      case final SuccessPurchase<CustomerInfo> success:
        state = AsyncData(buyState.copyWith(
          loadingAction: false,
          errorAction: null,
          isPremium:
              success.data.entitlements.active.containsKey(entitlementId),
        ));
      case final FailurePurchase f:
        state = AsyncData(buyState.copyWith(
          loadingAction: false,
          errorAction: f.error.message,
        ));
    }
  }

  void select(Package package) {
    final buyState = state.value;
    if (buyState == null) return;
    state = AsyncData(buyState.copyWith(selectedPackage: package));
  }

  void refreshPackages() {
    ref.read(subscriptionRepositoryProvider.notifier).refresh();
  }
}

@freezed
sealed class InfoBuyScreenState with _$InfoBuyScreenState {
  factory InfoBuyScreenState({
    required bool loadingAction,
    required String? errorAction,
    required bool isPremium,
    required List<Package>? packages,
    required Package? selectedPackage,
  }) = _InfoBuyScreenState;
}
