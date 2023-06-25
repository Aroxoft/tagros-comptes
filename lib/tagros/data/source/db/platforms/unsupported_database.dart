import 'package:drift/drift.dart';

class Database {
  Database._();

  static QueryExecutor openConnection() =>
      throw UnsupportedError('Platform not found');

  static void continueConfiguration() =>
      throw UnsupportedError('Platform not found');
}
