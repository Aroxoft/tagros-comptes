import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';

part 'subscription_state.freezed.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  factory SubscriptionState({
    required bool isPro,
    required bool isLoading,
    required List<Package> packages,
    required ErrorPurchase? error,
    required ErrorPurchase? temporaryError,
    required Package? selectedPackage,
  }) = _SubscriptionState;

  SubscriptionState._();

  bool get hasError => error != null;
}
