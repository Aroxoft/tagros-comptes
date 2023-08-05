import 'package:purchases_flutter/errors.dart';
import 'package:tagros_comptes/monetization/domain/subscribe.dart';

extension ErrorPurchaseMapper on PurchasesErrorCode {
  ErrorPurchase get error {
    switch (this) {
      case PurchasesErrorCode.purchaseCancelledError:
        return CancelledPurchase();
      case PurchasesErrorCode.unknownError:
        return UnknownError();
      case PurchasesErrorCode.productAlreadyPurchasedError:
        return AlreadyOwnedError();
      case PurchasesErrorCode.invalidCredentialsError:
        return InvalidCredentialsError();
      case PurchasesErrorCode.configurationError:
        return ConfigurationError();
      case PurchasesErrorCode.networkError:
        return NetworkError();
      case PurchasesErrorCode.paymentPendingError:
        return PaymentPendingError();
      default:
        return UnknownError();
    }
  }
}
