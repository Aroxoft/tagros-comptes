import 'package:purchases_flutter/errors.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';

extension ErrorPurchaseMapper on PurchasesErrorCode {
  ErrorPurchase get error {
    switch (this) {
      case PurchasesErrorCode.purchaseCancelledError:
        return ErrorPurchase.cancelled;
      case PurchasesErrorCode.unknownError:
        return ErrorPurchase.unknown;
      case PurchasesErrorCode.productAlreadyPurchasedError:
        return ErrorPurchase.alreadyOwned;
      case PurchasesErrorCode.invalidCredentialsError:
        return ErrorPurchase.invalidCredentials;
      case PurchasesErrorCode.configurationError:
        return ErrorPurchase.configuration;
      case PurchasesErrorCode.networkError:
        return ErrorPurchase.network;
      case PurchasesErrorCode.paymentPendingError:
        return ErrorPurchase.paymentPending;
      case PurchasesErrorCode.storeProblemError:
        return ErrorPurchase.storeProblem;
      default:
        return ErrorPurchase.unknown;
    }
  }
}
