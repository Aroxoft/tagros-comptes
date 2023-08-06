import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';

extension ErrorMapper on ErrorPurchase {
  String get message {
    return switch (this) {
      CancelledPurchase() => 'Purchase cancelled',
      UnknownError() => 'Unknown error',
      AlreadyOwnedError() => 'Already owned',
      InvalidCredentialsError() => 'Invalid credentials',
      ConfigurationError() => 'Configuration error: please contact support',
      NetworkError() => 'Network error',
      PaymentPendingError() => 'Payment pending',
      NoPackagesAvailableError() => 'No packages available',
      RestoreFailedError() => 'Restore failed',
    };
  }
}
