import 'dart:async';

import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/monetization/data/subscribe_service.dart';
import 'package:tagros_comptes/monetization/data/subscription_data.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';
import 'package:tagros_comptes/util/logger.dart';

part 'subscription_repository.g.dart';

const String entitlementId = "tagros_premium";

@Riverpod(keepAlive: true)
class SubscriptionRepository extends _$SubscriptionRepository {
  late final SubscriptionService _subscriptionService;
  late final Logger _logger;

  @override
  Future<SubscriptionData> build() {
    _subscriptionService = ref.watch(subscriptionServiceProvider);
    _logger = ref.watch(loggerProvider);
    return _loadMyCustomerInfo();
  }

  Future<SubscriptionData> _loadMyCustomerInfo() async {
    final customerInfoResult = await _subscriptionService.getCustomerInfo();
    CustomerInfo? customerInfo;
    switch (customerInfoResult) {
      case final SuccessPurchase<CustomerInfo> success:
        customerInfo = success.data;
      case final FailurePurchase f:
        _logger.logError(f.error, f.stack);
        return Future.error(f.error, f.stack);
    }
    final packagesResult = await _subscriptionService.getPackages();
    List<Package> packages;
    switch (packagesResult) {
      case final SuccessPurchase<List<Package>> success:
        packages = success.data;
      case final FailurePurchase f:
        _logger.logError(f.error, f.stack);
        return Future.error(f.error, f.stack);
    }
    return SubscriptionData(packages, customerInfo);
  }

  Future<PurchaseResult<CustomerInfo>> buy(Package package) async {
    final packages = state.whenOrNull(data: (value) => value.packages);
    if (packages == null) return Future.error('No packages found');
    final customerInfo = state.whenOrNull(data: (value) => value.customerInfo);
    if (customerInfo == null) return Future.error('No customer info found');
    final buy = await _subscriptionService.buy(package);
    switch (buy) {
      case final SuccessPurchase<CustomerInfo> success:
        state = AsyncValue.data(SubscriptionData(packages, success.data));
        return success;
      case final FailurePurchase f:
        return f;
    }
  }

  Future<PurchaseResult<CustomerInfo>> restorePurchase() async {
    final packages = state.whenOrNull(data: (value) => value.packages);
    if (packages == null) return Future.error('No packages found');
    final customerInfo = state.whenOrNull(data: (value) => value.customerInfo);
    if (customerInfo == null) return Future.error('No customer info found');
    final restore = await _subscriptionService.restore();
    switch (restore) {
      case final SuccessPurchase<CustomerInfo> success:
        state = AsyncValue.data(SubscriptionData(packages, success.data));
        return success;
      case final FailurePurchase f:
        return f;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    _loadMyCustomerInfo().then((value) {
      state = AsyncValue.data(value);
    }).onError((error, stack) {
      state = AsyncValue.error(error!, stack);
    }, test: (error) => error is Object);
  }

  Future<List<Package>> getPackages() async {
    final List<Package>? packages =
        state.whenOrNull(data: (value) => value.packages);
    if (packages != null) {
      return packages;
    }
    final customerInfo = state.whenOrNull(data: (value) => value.customerInfo);
    if (customerInfo == null) return Future.error('No customer info found');
    final purchaseResult = await _subscriptionService.getPackages();
    switch (purchaseResult) {
      case final SuccessPurchase<List<Package>> success:
        state = AsyncValue.data(SubscriptionData(success.data, customerInfo));
        return success.data;
      case final FailurePurchase f:
        return Future.error(f.error);
    }
  }
}
