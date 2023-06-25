import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';

part 'players_dao.g.dart';

@DriftAccessor(
  tables: [Players, PlayerGames],
  include: {'players_queries.drift'},
)
class PlayersDao extends DatabaseAccessor<AppDatabase> with _$PlayersDaoMixin {
  PlayersDao(super.db);

  /// Deletes all unused players (not in any game), and returns the number of
  /// rows affected
  Future<int> deleteAllUnused() async {
    final unused = await unusedPlayers().get();
    return (delete(players)
          ..where((tbl) => tbl.id.isIn(unused.map((e) => e.id).whereNotNull())))
        .go();
  }

  Future<void> deletePlayer(int? idPlayer) async {
    await (delete(players)..where((tbl) => tbl.id.equalsNullable(idPlayer)))
        .go();
  }

  Future<List<Player>> searchForPlayer(String search,
      {required List<int> notIn}) {
    if (search.isEmpty) {
      return (select(players)
            ..where((tbl) => tbl.id.isNotIn(notIn))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.pseudo)])
            ..limit(10))
          .get();
    }
    return (select(players)
          ..where((tbl) => tbl.id.isNotIn(notIn))
          ..where((tbl) => tbl.pseudo.contains(search))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.pseudo)]))
        .get();
  }

  Future<Player> addOrGetByName({required String name}) async {
    var player = await (select(players)
          ..where((tbl) => tbl.pseudo.lower().equals(name.toLowerCase())))
        .getSingleOrNull();
    // if player null then create it
    if (player == null) {
      final playerInsert = PlayersCompanion.insert(pseudo: name);
      final id = await into(players).insert(playerInsert);
      player = Player(id: id, pseudo: name);
    }
    // then return it
    return player;
  }
}
