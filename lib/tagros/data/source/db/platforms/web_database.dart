import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

class Database {
  Database._();

  static DatabaseConnection connect() {
    return DatabaseConnection.delayed(Future(() async {
      final db = await WasmDatabase.open(
        databaseName: 'points_db',
        sqlite3Uri: Uri.parse('/sqlite3.wasm'),
        driftWorkerUri: Uri.parse('/drift_worker.js'),
      );
      if (db.missingFeatures.isNotEmpty) {
        debugPrint('Using ${db.chosenImplementation} due to unsupported '
            'browser features: ${db.missingFeatures}');
      }
      return db.resolvedExecutor;
    }));
  }

  static Future<void> validateDatabaseScheme(GeneratedDatabase database) async {
    // Unfortunately, validating database schemas only works for native platforms
    // right now.
    // As we also have migration tests (see the `Testing migrations` section in
    // drift documentation), this is not a huge issue.
  }
}
