import 'package:drift/drift.dart';
import 'package:tagros_comptes/services/db/app_database.dart';

part 'players_dao.g.dart';

@DriftAccessor(
  tables: [Players, PlayerGames],
  include: {'players_queries.drift'},
)
class PlayersDao extends DatabaseAccessor<AppDatabase> with _$PlayersDaoMixin {
  PlayersDao(AppDatabase db) : super(db);

  /// Deletes all unused players (not in any game), and returns the number of
  /// rows affected
  Future<int> deleteAllUnused() async {
    final unused = await unusedPlayers().get();
    return (delete(players)
          ..where((tbl) => tbl.id.isIn(unused.map((e) => e.id))))
        .go();
  }

  Future<void> deletePlayer(int? idPlayer) async {
    await (delete(players)..where((tbl) => tbl.id.equals(idPlayer))).go();
  }
}
