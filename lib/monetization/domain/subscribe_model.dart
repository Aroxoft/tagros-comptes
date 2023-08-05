sealed class PurchaseResult<T> {
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

class RestoreFailedError extends ErrorPurchase {}

class CancelledPurchase extends ErrorPurchase {}

class UnknownError extends ErrorPurchase {}

class AlreadyOwnedError extends ErrorPurchase {}

class InvalidCredentialsError extends ErrorPurchase {}

class ConfigurationError extends ErrorPurchase {}

class NetworkError extends ErrorPurchase {}

class PaymentPendingError extends ErrorPurchase {}

class NoPackagesAvailableError extends ErrorPurchase {}
