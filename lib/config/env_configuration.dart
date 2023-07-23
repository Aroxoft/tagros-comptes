import 'package:tagros_comptes/config/platform_configuration.dart';

class AdsConfiguration {
  final Map<String, String?> _environment;
  final PlatformConfiguration _platformConfiguration;

  AdsConfiguration(this._environment, this._platformConfiguration);

  // region Test ads ids
  /// android test banner id
  final String _androidTestBannerId = "ca-app-pub-3940256099942544/6300978111";

  /// ios test banner id
  final String _iosTestBannerId = "ca-app-pub-3940256099942544/2934735716";

  /// android test native id
  final String _androidTestNativeId = "ca-app-pub-3940256099942544/2247696110";

  /// ios test native id
  final String _iosTestNativeId = "ca-app-pub-3940256099942544/3986624511";

  // endregion

// getter for test ads
  bool get _testAds => _environment["testAds"] == "true";

// getter for android banner id
  String get _androidBannerId => _environment["androidBannerId"]!;

// getter for ios banner id
  String get _iosBannerId => _environment["iosBannerId"]!;

// getter for android app id
  String get _androidAppId => _environment["androidAppId"]!;

// getter for ios app id
  String get _iosAppId => _environment["iosAppId"]!;

// getter for android native id
  String get _androidNativeId => _environment["androidNativeId"]!;

// getter for ios native id
  String get _iosNativeId => _environment["iosNativeId"]!;

  /// Get the banner id based on the platform
  String get bannerId {
    if (_testAds) {
      return _platformConfiguration.isAndroid
          ? _androidTestBannerId
          : _iosTestBannerId;
    }
    return _platformConfiguration.isAndroid ? _androidBannerId : _iosBannerId;
  }

  /// Get the native id based on the platform
  String get nativeId {
    if (_testAds) {
      return _platformConfiguration.isAndroid
          ? _androidTestNativeId
          : _iosTestNativeId;
    }
    return _platformConfiguration.isAndroid ? _androidNativeId : _iosNativeId;
  }

  /// Get the app id based on the platform
  String get appId {
    return _platformConfiguration.isAndroid ? _androidAppId : _iosAppId;
  }
}
