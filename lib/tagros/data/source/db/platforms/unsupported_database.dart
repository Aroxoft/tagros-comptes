import 'package:drift/drift.dart';

class Database {
  Database._();

  static DatabaseConnection connect() =>
      throw UnsupportedError('Platform not found');

  static Future<void> validateDatabaseScheme(GeneratedDatabase database) =>
      throw UnsupportedError('Platform not found');
}
