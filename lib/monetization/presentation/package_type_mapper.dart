import 'package:flutter/material.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:tagros_comptes/generated/l10n.dart';

extension PackageTypeMapper on PackageType {
  String displayName(BuildContext context) {
    switch (this) {
      case PackageType.lifetime:
        return S.of(context).subscription_packageType_lifetime_display;
      case PackageType.annual:
        return S.of(context).subscription_packageType_annual_display;
      case PackageType.sixMonth:
        return S.of(context).subscription_packageType_sixMonth_display;
      case PackageType.threeMonth:
        return S.of(context).subscription_packageType_threeMonth_display;
      case PackageType.twoMonth:
        return S.of(context).subscription_packageType_twoMonth_display;
      case PackageType.monthly:
        return S.of(context).subscription_packageType_monthly_display;
      case PackageType.weekly:
        return S.of(context).subscription_packageType_weekly_display;
      default:
        return S.of(context).subscription_packageType_unknown_display;
    }
  }

  String paidString(BuildContext context) {
    switch (this) {
      case PackageType.lifetime:
        return S.of(context).subscription_packageType_lifetime_paid;
      case PackageType.annual:
        return S.of(context).subscription_packageType_annual_paid;
      case PackageType.sixMonth:
        return S.of(context).subscription_packageType_sixMonth_paid;
      case PackageType.threeMonth:
        return S.of(context).subscription_packageType_threeMonth_paid;
      case PackageType.twoMonth:
        return S.of(context).subscription_packageType_twoMonth_paid;
      case PackageType.monthly:
        return S.of(context).subscription_packageType_monthly_paid;
      case PackageType.weekly:
        return S.of(context).subscription_packageType_weekly_paid;
      default:
        return S.of(context).subscription_packageType_unknown_paid;
    }
  }
}
