import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart'
    show
        CustomerInfo,
        LogInResult,
        LogLevel,
        Package,
        Purchases,
        PurchasesConfiguration,
        PurchasesErrorHelper;
import 'package:tagros_comptes/config/platform_configuration.dart';
import 'package:tagros_comptes/monetization/domain/error_purchase_mapper.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';
import 'package:tagros_comptes/util/logger.dart';

class SubscriptionService {
  final PlatformConfiguration _platform;
  LogInResult? _loginResult;
  final Completer<void> _completer = Completer<void>();
  final Logger _logger;

  late final Future<void> _initialized;

  SubscriptionService(PlatformConfiguration platform, Logger logger)
      : _platform = platform,
        _logger = logger {
    _initialized = _completer.future;
    _init();
  }

  bool platformIsSupported() {
    // todo add iOS support when launching for iOS
    return _platform.isAndroid;
  }

  Future<void> _init() async {
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
      _logger.logError('Platform not supported');
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

  Future<PurchaseResult<CustomerInfo>> buy(Package package) {
    return _safeCall<PurchaseResult<CustomerInfo>>(
      () async {
        final info = await Purchases.purchasePackage(package);
        _logger.log('purchase: $info');
        return PurchaseResult.value(info.customerInfo);
      },
      onError: (e, stack) {
        final errorCode = PurchasesErrorHelper.getErrorCode(e);
        return PurchaseResult.error(errorCode.error, stack);
      },
    );
  }

  Future<PurchaseResult<CustomerInfo>> restore() {
    return _safeCall(() async {
      final purchaserInfo = await Purchases.restorePurchases();
      _logger.log('restore: $purchaserInfo');
      return PurchaseResult.value(purchaserInfo);
    }, onError: (error, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(error);
      _logger.log('restore error: $error, errorCode: $errorCode');
      return PurchaseResult.error(ErrorPurchase.restoreFailed, stack);
    });
  }

  Future<PurchaseResult<List<Package>>> getPackages() {
    return _safeCall(() async {
      final offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        // todo show packages for sale
        _logger.log('offerings: $offerings');
        return PurchaseResult.value(offerings.current!.availablePackages);
      }
      return PurchaseResult.error(ErrorPurchase.noPackagesAvailable, null);
    }, onError: (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      return PurchaseResult.error(errorCode.error, stack);
    });
  }

  Future<PurchaseResult<void>> login(String userId) {
    return _safeCall(() async {
      _loginResult = await Purchases.logIn(userId);
      _logger.log('identify: $_loginResult');
      void t;
      return PurchaseResult.value(t);
    }, onError: (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      _logger.log('login error: $e');
      return PurchaseResult.error(errorCode.error, stack);
    });
  }

  Future<PurchaseResult<CustomerInfo>> getCustomerInfo() {
    return _safeCall(() async {
      final customerInfo = await Purchases.getCustomerInfo();
      _logger.log('myPurchases: $customerInfo');
      return PurchaseResult.value(customerInfo);
    }, onError: (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      _logger.log('myPurchases error: $e, errorCode: $errorCode');
      return PurchaseResult.error(errorCode.error, stack);
    });
  }
}

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService(
    ref.watch(platformConfigProvider),
    ref.watch(loggerProvider),
  );
});
