import 'package:drift/drift.dart';
import 'package:tagros_comptes/services/db/app_database.dart';

part 'games_dao.g.dart';

@DriftAccessor(tables: [Games], include: {'games_queries.drift'})
class GamesDao extends DatabaseAccessor with _$GamesDaoMixin {
  GamesDao(AppDatabase db) : super(db);

}
