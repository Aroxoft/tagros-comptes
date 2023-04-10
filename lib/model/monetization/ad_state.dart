import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tagros_comptes/.env.dart';
import 'package:universal_platform/universal_platform.dart';

abstract class AdState {
  AdState();

  /// Initialize admob for mobile
  factory AdState.construct() {
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      return AdStateMobile();
    }
    return AdStateOther();
  }

  Future<void> get initialization;

  String get bannerAdUnitId {
    String? id;
    if (UniversalPlatform.isAndroid) {
      id = environment['androidBannerId'];
    } else if (UniversalPlatform.isIOS) {
      id = environment['iosBannerId'];
    }
    return id ?? '';
  }

  String get nativeAdUnitId {
    String? id;
    if (UniversalPlatform.isAndroid) {
      id = environment['androidNativeId'];
    } else if (UniversalPlatform.isIOS) {
      id = environment['iosNativeId'];
    }
    return id ?? '';
  }
}

/// Admob initialization for mobile
class AdStateMobile extends AdState {
  final Future<InitializationStatus> _initialization;

  AdStateMobile() : _initialization = MobileAds.instance.initialize();

  @override
  Future<void> get initialization async {
    await _initialization;
  }
}

/// AdMob is not supported elsewhere (other than mobile)
class AdStateOther extends AdState {
  @override
  Future<void> get initialization => Future.value();
}
