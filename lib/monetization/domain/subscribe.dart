import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/config/platform_configuration.dart';
import 'package:tagros_comptes/monetization/domain/error_purchase_mapper.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';

part 'subscribe.g.dart';

const String entitlementId = "tagros_premium";

@Riverpod(keepAlive: true)
class SubscriptionService extends _$SubscriptionService {
  late final PlatformConfiguration _platform;
  LogInResult? _loginResult;
  final Completer<void> _completer = Completer<void>();

  late final Future<void> _initialized;

  SubscriptionService() {
    _initialized = _completer.future;
  }

  bool platformIsSupported() {
    // todo add iOS support when launching for iOS
    return _platform.isAndroid;
  }

  @override
  Future<void> build() async {
    _platform = ref.read(platformConfigProvider);
    if (!platformIsSupported()) {
      return;
    }
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration? configuration;
    if (_platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_fzANVxcxoUVupDjviLehkrScycQ");
    }
    // todo: add iOS key when launching for iOS
    // else if (platform.isIOS) {
    //   configuration = PurchasesConfiguration(<public_ios_sdk_key>);
    // }
    if (configuration == null) {
      // Platform not supported
      if (kDebugMode) {
        throw Exception('Platform not supported');
      }
      return;
    }

    await Purchases.configure(configuration);
    _completer.complete();
  }

  Future<T> _safeCall<T>(Future<T> Function() function,
      {required T Function(PlatformException e, StackTrace stackTrace)
          onError}) async {
    await _initialized;
    try {
      return await function();
    } on PlatformException catch (e, stack) {
      return onError(e, stack);
    }
  }

  bool isPro(CustomerInfo customerInfo) {
    return customerInfo.entitlements.all[entitlementId]?.isActive == true;
  }

  Future<bool> hasPro() {
    return _safeCall(() async {
      final purchaseResult = await _getEntitlements();
      switch (purchaseResult) {
        case FailurePurchase():
          return false;
        case SuccessPurchase<Map<String, EntitlementInfo>>():
          return purchaseResult.data[entitlementId]?.isActive == true;
      }
    }, onError: (error, stack) {
      if (kDebugMode) {
        print('isPro error: $error');
      }
      return false;
    });
  }

  Future<PurchaseResult<CustomerInfo>> purchase(Package package) async {
    return _safeCall<PurchaseResult<CustomerInfo>>(
      () async {
        final purchase = await Purchases.purchasePackage(package);
        if (purchase.entitlements.all[entitlementId]?.isActive == true) {
          if (kDebugMode) {
            print('purchase: $purchase');
          }
          // todo unlock premium features
        } else {
          if (kDebugMode) {
            print(
                "We didn't unlock premium purchase, we instead have purchased: ${purchase.entitlements.active.keys}");
          }
        }
        return PurchaseResult.value(purchase);
      },
      onError: (e, stack) {
        final errorCode = PurchasesErrorHelper.getErrorCode(e);
        return PurchaseResult.error(errorCode.error, stack);
      },
    );
  }

  Future<bool> restore() async {
    return _safeCall(() async {
      final purchaserInfo = await Purchases.restorePurchases();
      if (kDebugMode) {
        print('restore: $purchaserInfo');
      }
      return purchaserInfo.entitlements.all[entitlementId]?.isActive == true;
    }, onError: (error, stack) {
      if (kDebugMode) {
        print('restore error: $error');
      }
      return false;
    });
  }

  Future<PurchaseResult<List<Package>>> getPackages() async {
    return _safeCall(() async {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        // todo show packages for sale
        if (kDebugMode) {
          print('offerings: $offerings');
        }
        return PurchaseResult.value(offerings.current!.availablePackages);
      }
      return PurchaseResult.error(NoPackagesAvailableError(), null);
    }, onError: (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      return PurchaseResult.error(errorCode.error, stack);
    });
  }

  /// Get my entitlements
  Future<PurchaseResult<Map<String, EntitlementInfo>>>
      _getEntitlements() async {
    return _safeCall(() async {
      final customerInfo = await Purchases.getCustomerInfo();
      return PurchaseResult.value(customerInfo.entitlements.active);
    }, onError: (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (kDebugMode) {
        print('entitlements error: $e $stack');
      }
      return PurchaseResult.error(errorCode.error, stack);
    });
  }

  Future<PurchaseResult<void>> login(String userId) async {
    return _safeCall(() async {
      _loginResult = await Purchases.logIn(userId);
      if (kDebugMode) {
        print('identify: $_loginResult');
      }
      void t;
      return PurchaseResult.value(t);
    }, onError: (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (kDebugMode) {
        print('login error: $e');
      }
      return PurchaseResult.error(errorCode.error, stack);
    });
  }
}
