import 'package:flutter_test/flutter_test.dart';
import 'package:tagros_comptes/services/config/env_configuration.dart';
import 'package:tagros_comptes/services/config/platform_configuration.dart';

void main() {
  group('Given a test environment', () {
    final fakeEnvironment = {
      "testAds": "true",
      "androidBannerId": "androidBannerId",
      "iosBannerId": "iosBannerId",
      "androidAppId": "androidAppId",
      "iosAppId": "iosAppId",
      "androidNativeId": "androidNativeId",
      "iosNativeId": "iosNativeId",
    };

    // group with a fake platform configuration that is android
    group('When platform is android', () {
      final PlatformConfiguration fakePlatformConfiguration =
          PlatformConfiguration(
              isAndroid: true,
              isIOS: false,
              isWeb: false,
              isMacOS: false,
              isWindows: false,
              isLinux: false,
              isDesktop: false,
              isFuchsia: false);

      final AdsConfiguration adsConfiguration =
          AdsConfiguration(fakeEnvironment, fakePlatformConfiguration);
      test('Banner id is android test banner id', () {
        expect(adsConfiguration.bannerId,
            "ca-app-pub-3940256099942544/6300978111");
      });

      // Native id should be the android test native id
      test('Native id is android test native id', () {
        expect(adsConfiguration.nativeId,
            "ca-app-pub-3940256099942544/2247696110");
      });

      // App id should be the android app id
      test('App id is android app id', () {
        expect(adsConfiguration.appId, "androidAppId");
      });
    });

    // group with a fake platform configuration that is ios
    group('When platform is ios', () {
      final PlatformConfiguration fakePlatformConfiguration =
          PlatformConfiguration(
              isAndroid: false,
              isIOS: true,
              isWeb: false,
              isMacOS: false,
              isWindows: false,
              isLinux: false,
              isDesktop: false,
              isFuchsia: false);

      final AdsConfiguration adsConfiguration =
          AdsConfiguration(fakeEnvironment, fakePlatformConfiguration);
      test('Banner id is ios test banner id', () {
        expect(adsConfiguration.bannerId,
            "ca-app-pub-3940256099942544/2934735716");
      });

      // Native id should be the ios test native id
      test('Native id is ios test native id', () {
        expect(adsConfiguration.nativeId,
            "ca-app-pub-3940256099942544/3986624511");
      });

      // App id should be the ios app id
      test('App id is ios app id', () {
        expect(adsConfiguration.appId, "iosAppId");
      });
    });
  });

  // Given a production environment
  group('Given a production environment', () {
    final fakeEnvironment = {
      "testAds": "false",
      "androidBannerId": "androidBannerId",
      "iosBannerId": "iosBannerId",
      "androidAppId": "androidAppId",
      "iosAppId": "iosAppId",
      "androidNativeId": "androidNativeId",
      "iosNativeId": "iosNativeId",
    };

    // group with a fake platform configuration that is android
    group('When platform is android', () {
      final PlatformConfiguration fakePlatformConfiguration =
          PlatformConfiguration(
              isAndroid: true,
              isIOS: false,
              isWeb: false,
              isMacOS: false,
              isWindows: false,
              isLinux: false,
              isDesktop: false,
              isFuchsia: false);

      final AdsConfiguration adsConfiguration =
          AdsConfiguration(fakeEnvironment, fakePlatformConfiguration);
      test('Banner id is android banner id', () {
        expect(adsConfiguration.bannerId, "androidBannerId");
      });

      // Native id should be the android native id
      test('Native id is android native id', () {
        expect(adsConfiguration.nativeId, "androidNativeId");
      });

      // App id should be the android app id
      test('App id is android app id', () {
        expect(adsConfiguration.appId, "androidAppId");
      });
    });

    // group with a fake platform configuration that is ios
    group('When platform is ios', () {
      final PlatformConfiguration fakePlatformConfiguration =
          PlatformConfiguration(
              isAndroid: false,
              isIOS: true,
              isWeb: false,
              isMacOS: false,
              isWindows: false,
              isLinux: false,
              isDesktop: false,
              isFuchsia: false);

      final AdsConfiguration adsConfiguration =
          AdsConfiguration(fakeEnvironment, fakePlatformConfiguration);
      test('Banner id is ios banner id', () {
        expect(adsConfiguration.bannerId, "iosBannerId");
      });

      // Native id should be the ios native id
      test('Native id is ios native id', () {
        expect(adsConfiguration.nativeId, "iosNativeId");
      });

      // App id should be the ios app id
      test('App id is ios app id', () {
        expect(adsConfiguration.appId, "iosAppId");
      });
    });
  });
}
