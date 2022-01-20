import 'dart:ffi';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/open.dart';

class Database {
  Database._();

  static QueryExecutor openConnection() {
    continueConfiguration();
    // the LazyDatabase util lets us find the right location for the file async.
    return LazyDatabase(() async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      Directory dbFolder;
      if (Platform.isWindows) {
        dbFolder = Directory('./data/db/');
      } else {
        dbFolder = Directory(join(
            (await getApplicationDocumentsDirectory()).parent.path,
            'databases/fertility/'));
      }

      final file = File(join(dbFolder.path, 'fertility.db'));
      if (kDebugMode) {
        print('path db: ${file.absolute.path}');
      }
      return NativeDatabase(file);
    });
  }

  static void continueConfiguration() {
    open
      ..overrideFor(
          OperatingSystem.windows, () => _sqliteOpenOnDesktop(windows: true))
      ..overrideFor(OperatingSystem.linux, _sqliteOpenOnDesktop);
  }

  static DynamicLibrary _sqliteOpenOnDesktop({bool windows = true}) {
    final dir = Directory(
        '${File(Platform.script.toFilePath(windows: windows)).parent.path}'
        '/${windows ? 'windows' : 'linux'}/sqlite');
    final libraryPath = File('${dir.path}/sqlite3.${windows ? 'dll' : 'so'}');
    return DynamicLibrary.open(libraryPath.path);
  }
}
