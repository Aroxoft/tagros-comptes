//This file is in `./tool` folder

import 'dart:convert';
import 'dart:io';

// To compile you need to run the following command to generate .env.dart file in lib
// -->   dart tool/env.dart
// command to be run in project root Directory

Future<void> main() async {
  final config = {
    'androidBannerId': Platform.environment['ANDROID_BANNER_ID'],
    'iosBannerId': Platform.environment['IOS_BANNER_ID'],
    'iosAppId': Platform.environment['IOS_APP_ID'],
    'androidAppId': Platform.environment['ANDROID_APP_ID'],
    'androidNativeId': Platform.environment['ANDROID_NATIVE_ID'],
    'iosNativeId': Platform.environment['IOS_NATIVE_ID'],
    'testAds': Platform.environment['TEST_ADS'],
  };

  const filename = 'lib/.env.dart';
  await File(filename).writeAsString(
      'final Map<String, String?> environment = ${json.encode(config)};');
}
