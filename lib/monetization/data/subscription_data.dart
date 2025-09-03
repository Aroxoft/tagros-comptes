import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/monetization/data/subscription_repository.dart';

part 'subscription_data.freezed.dart';

@freezed
sealed class SubscriptionData with _$SubscriptionData {
  factory SubscriptionData(
    List<Package>? packages,
    CustomerInfo customerInfo,
  ) = _SubscriptionData;

  SubscriptionData._();

  bool get isPremium =>
      customerInfo.entitlements.active.containsKey(entitlementId);
}
