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

enum ErrorPurchase {
  restoreFailed(1),
  cancelled(2),
  unknown(3),
  alreadyOwned(4),
  invalidCredentials(5),
  configuration(6),
  network(7),
  paymentPending(8),
  noPackagesAvailable(9),
  storeProblem(10);

  const ErrorPurchase(this.code);

  final int code;
}
