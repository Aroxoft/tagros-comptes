import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final FlutterDriver driver = await FlutterDriver.connect();
  return integrationDriver(
    driver: driver,
    onScreenshot: (String screenshotName, List<int> screenshotBytes,
        [Map<String, Object?>? args]) async {
      try {
        final splits = screenshotName.split('_');
        final String locale;
        switch (splits[1]) {
          case 'fr':
            locale = 'fr-FR';
          case 'en':
            locale = 'en-US';
          default:
            locale = 'unknown';
        }
        final deviceFolder = splits[2];
        final name = splits[0];
        final screenshotPath =
            'android/fastlane/metadata/android/$locale/images/$deviceFolder/${name}_$locale.png';
        final file = await File(screenshotPath).create(recursive: true);
        await file.writeAsBytes(screenshotBytes);
        return true;
      } catch (e) {
        return false;
      }
    },
  );
}
