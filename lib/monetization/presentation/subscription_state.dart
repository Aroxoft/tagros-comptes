import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/monetization/domain/subscribe.dart';

part 'subscription_state.freezed.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  factory SubscriptionState.pro() = _Pro;

  factory SubscriptionState.loading() = _Loading;

  factory SubscriptionState.offers(
      {required List<Package> packages, ErrorPurchase? temporaryError}) = _Offers;

  factory SubscriptionState.error(ErrorPurchase error) = _Error;

  SubscriptionState._();
}
