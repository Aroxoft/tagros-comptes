import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  Database._();

  static DatabaseConnection connect() {
    return DatabaseConnection.delayed(Future(() async {
      return NativeDatabase.createBackgroundConnection(await _databaseFile);
    }));
  }

  static Future<File> get _databaseFile async {
    Directory dbFolder;
    if (Platform.isWindows) {
      dbFolder = Directory('./data/db/');
    } else {
      dbFolder = Directory(join(
          (await getApplicationDocumentsDirectory()).parent.path,
          'databases/'));
    }
    final file = File(join(dbFolder.path, 'points.db'));
    if (kDebugMode) {
      print('path db: ${file.absolute.path}');
    }
    return file;
  }

  static Future<void> validateDatabaseScheme(GeneratedDatabase database) async {
    // This method validates that the actual schema of the opened database matches
    // the tables, views, triggers and indices for which drift_dev has generated
    // code.
    // Validating the database's schema after opening it is generally a good idea,
    // since it allows us to get an early warning if we change a table definition
    // without writing a schema migration for it.
    //
    // For details, see: https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime
    if (kDebugMode) {
      await VerifySelf(database).validateDatabaseSchema();
    }
  }
}
