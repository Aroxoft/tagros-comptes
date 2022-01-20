import 'package:drift/drift.dart';
import 'package:drift/web.dart';

class Database {
  Database._();

  static QueryExecutor openConnection() => WebDatabase('app');

  static void continueConfiguration() {}
}
