import 'package:flutter/material.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/monetization/domain/subscribe_model.dart';

extension ErrorMapper on ErrorPurchase {
  String get message {
    return switch (this) {
      ErrorPurchase.cancelled =>
        S.current.subscription_errorPurchase_cancelled_snackMessage,
      ErrorPurchase.unknown =>
        S.current.subscription_errorPurchase_unknown_snackMessage,
      ErrorPurchase.alreadyOwned =>
        S.current.subscription_errorPurchase_alreadyOwned_snackMessage,
      ErrorPurchase.invalidCredentials =>
        S.current.subscription_errorPurchase_invalidCredentials_snackMessage,
      ErrorPurchase.configuration =>
        S.current.subscription_errorPurchase_configuration_snackMessage,
      ErrorPurchase.network =>
        S.current.subscription_errorPurchase_network_snackMessage,
      ErrorPurchase.paymentPending =>
        S.current.subscription_errorPurchase_paymentPending_snackMessage,
      ErrorPurchase.noPackagesAvailable =>
        S.current.subscription_errorPurchase_noPackagesAvailable_snackMessage,
      ErrorPurchase.restoreFailed =>
        S.current.subscription_errorPurchase_restoreFailed_snackMessage,
      ErrorPurchase.storeProblem =>
        S.current.subscription_errorPurchase_storeProblem_snackMessage,
    };
  }

  String errorTitle(BuildContext context) {
    switch (this) {
      case ErrorPurchase.cancelled:
        return S.of(context).subscription_errorPurchase_cancelled_title;
      case ErrorPurchase.network:
        return S.of(context).subscription_errorPurchase_network_title;
      case ErrorPurchase.storeProblem:
        return S.of(context).subscription_errorPurchase_storeProblem_title;
      default:
        return S.of(context).subscription_errorPurchase_default_title;
    }
  }

  String errorMessage(BuildContext context) {
    switch (this) {
      case ErrorPurchase.cancelled:
        return S.of(context).subscription_errorPurchase_cancelled_message;
      case ErrorPurchase.network:
        return S.of(context).subscription_errorPurchase_network_message;
      default:
        return S.of(context).subscription_errorPurchase_default_message(code);
    }
  }

  bool get canRetry {
    switch (this) {
      case ErrorPurchase.network:
        return true;
      default:
        return false;
    }
  }
}
