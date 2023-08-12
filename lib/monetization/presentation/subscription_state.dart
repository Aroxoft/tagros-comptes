import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/monetization/data/subscription_repository.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';

part 'subscription_state.freezed.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  factory SubscriptionState({
    required bool isLoading,
    required List<Package>? packages,
    required CustomerInfo? customerInfo,
    required ErrorPurchase? error,
    required ErrorPurchase? temporaryError,
  }) = _SubscriptionState;

  SubscriptionState._();

  bool get hasError => error != null;

  bool get hasPackages => packages != null;

  bool get isPremium =>
      customerInfo?.entitlements.active.containsKey(entitlementId) ?? false;
}
