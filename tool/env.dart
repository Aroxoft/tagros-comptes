//This file is in `./tool` folder

import 'dart:convert';
import 'dart:io';

// To compile you need to run the following command to generate .env.dart file in lib
// -->   dart tool/env.dart
// command to be run in project root Directory

Future<void> main() async {
  final config = {
    'appSpector': Platform.environment['APPSPECTOR'],
    'appSpectorIos': Platform.environment['APPSPECTORIOS'],
  };

  const filename = 'lib/.env.dart';
  await File(filename).writeAsString(
      'final Map<String, String?> environment = ${json.encode(config)};');
}
