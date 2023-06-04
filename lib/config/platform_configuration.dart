import 'package:universal_platform/universal_platform.dart';

class PlatformConfiguration {
  bool _isAndroid;
  bool _isIOS;
  bool _isWeb;
  bool _isWindows;
  bool _isMacOS;
  bool _isLinux;
  bool _isFuchsia;
  bool _isDesktop;

  PlatformConfiguration(
      {bool? isAndroid,
      bool? isIOS,
      bool? isWeb,
      bool? isWindows,
      bool? isMacOS,
      bool? isLinux,
      bool? isFuchsia,
      bool? isDesktop})
      : _isAndroid = false,
        _isIOS = false,
        _isWeb = false,
        _isWindows = false,
        _isMacOS = false,
        _isLinux = false,
        _isFuchsia = false,
        _isDesktop = false {
    _isAndroid = isAndroid ?? UniversalPlatform.isAndroid;
    _isIOS = isIOS ?? UniversalPlatform.isIOS;
    _isWeb = isWeb ?? UniversalPlatform.isWeb;
    _isWindows = isWindows ?? UniversalPlatform.isWindows;
    _isMacOS = isMacOS ?? UniversalPlatform.isMacOS;
    _isLinux = isLinux ?? UniversalPlatform.isLinux;
    _isFuchsia = isFuchsia ?? UniversalPlatform.isFuchsia;
    _isDesktop = isDesktop ?? UniversalPlatform.isDesktop;
  }

  bool get isAndroid => _isAndroid;

  bool get isIOS => _isIOS;

  bool get isWeb => _isWeb;

  bool get isWindows => _isWindows;

  bool get isMacOS => _isMacOS;

  bool get isLinux => _isLinux;

  bool get isFuchsia => _isFuchsia;

  bool get isDesktop => _isDesktop;
}
