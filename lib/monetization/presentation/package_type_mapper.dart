import 'package:purchases_flutter/models/package_wrapper.dart';

extension PackageTypeMapper on PackageType {
  String get displayName {
    switch (this) {
      case PackageType.lifetime:
        return "À vie";
      case PackageType.annual:
        return "1 An";
      case PackageType.sixMonth:
        return "6 Mois";
      case PackageType.threeMonth:
        return "3 Mois";
      case PackageType.twoMonth:
        return "2 Mois";
      case PackageType.monthly:
        return "1 Mois";
      case PackageType.weekly:
        return "1 Semaine";
      default:
        return "Inconnu";
    }
  }

  String get paidString {
    switch (this) {
      case PackageType.lifetime:
        return "Facturé une fois";
      case PackageType.annual:
        return "Facturé annuellement";
      case PackageType.sixMonth:
        return "Facturé tous les 6 mois";
      case PackageType.threeMonth:
        return "Facturé tous les 3 mois";
      case PackageType.twoMonth:
        return "Facturé tous les 2 mois";
      case PackageType.monthly:
        return "Facturé tous les mois";
      case PackageType.weekly:
        return "Facturé toutes les semaines";
      default:
        return "Inconnu";
    }
  }
}
