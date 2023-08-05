import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/config/platform_configuration.dart';
import 'package:tagros_comptes/monetization/domain/error_purchase_mapper.dart';

part 'subscribe.g.dart';

const String entitlementId = "premium";

@Riverpod(keepAlive: true)
class SubscriptionService extends _$SubscriptionService {
  late final PlatformConfiguration _platform;
  LogInResult? _loginResult;

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
  }

  bool isPro(CustomerInfo customerInfo) {
    return customerInfo.entitlements.all[entitlementId]?.isActive == true;
  }

  Future<PurchaseResult<CustomerInfo>> purchase(Package package) async {
    try {
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
    } on PlatformException catch (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        if (kDebugMode) {
          print('purchase error: $e');
        }
        // todo show error
      }
      return PurchaseResult.error(errorCode.error, stack);
    }
  }

  Future<bool> restore() async {
    try {
      final purchaserInfo = await Purchases.restorePurchases();
      if (kDebugMode) {
        print('restore: $purchaserInfo');
      }
      return purchaserInfo.entitlements.all[entitlementId]?.isActive == true;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('restore error: $e');
      }
      return false;
    }
  }

  Future<PurchaseResult<List<Package>>> getPackages() async {
    try {
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
    } on PlatformException catch (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      return PurchaseResult.error(errorCode.error, stack);
    }
  }

  /// Get my entitlements
  Future<PurchaseResult<Map<String, EntitlementInfo>>> getEntitlements() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return PurchaseResult.value(customerInfo.entitlements.active);
    } on PlatformException catch (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (kDebugMode) {
        print('entitlements error: $e $stack');
      }
      return PurchaseResult.error(errorCode.error, stack);
    }
  }

  Future<PurchaseResult<void>> login(String userId) async {
    try {
      _loginResult = await Purchases.logIn(userId);
      if (kDebugMode) {
        print('identify: $_loginResult');
      }
      void t;
      return PurchaseResult.value(t);
    } on PlatformException catch (e, stack) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (kDebugMode) {
        print('identify error: $e');
      }
      return PurchaseResult.error(errorCode.error, stack);
    }
  }
}

abstract class PurchaseResult<T> {
  factory PurchaseResult.value(T data) = SuccessPurchase<T>;

  factory PurchaseResult.error(ErrorPurchase error, [StackTrace? stack]) =>
      FailurePurchase(error, stack);
}

class SuccessPurchase<T> implements PurchaseResult<T> {
  final T data;

  SuccessPurchase(this.data);
}

class FailurePurchase implements PurchaseResult<Never> {
  final ErrorPurchase error;
  final StackTrace? stack;

  FailurePurchase(this.error, [this.stack]);
}

sealed class ErrorPurchase {}

class CancelledPurchase extends ErrorPurchase {}

class UnknownError extends ErrorPurchase {}

class AlreadyOwnedError extends ErrorPurchase {}

class InvalidCredentialsError extends ErrorPurchase {}

class ConfigurationError extends ErrorPurchase {}

class NetworkError extends ErrorPurchase {}

class PaymentPendingError extends ErrorPurchase {}

class NoPackagesAvailableError extends ErrorPurchase {}
