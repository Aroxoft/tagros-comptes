import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';

extension ErrorMapper on ErrorPurchase {
  String get message {
    return switch (this) {
      ErrorPurchase.cancelled => 'Purchase cancelled',
      ErrorPurchase.unknown => 'Unknown error',
      ErrorPurchase.alreadyOwned => 'Already owned',
      ErrorPurchase.invalidCredentials => 'Invalid credentials',
      ErrorPurchase.configuration =>
        'Configuration error: please contact support',
      ErrorPurchase.network => 'Network error',
      ErrorPurchase.paymentPending => 'Payment pending',
      ErrorPurchase.noPackagesAvailable => 'No packages available',
      ErrorPurchase.restoreFailed => 'Restore failed',
      ErrorPurchase.storeProblem => 'Store problem',
    };
  }
}
