import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/domain/calculus.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/repository/tableau_repository.dart';
import 'package:tuple/tuple.dart';

class TableauRepositoryImpl implements TableauRepository {
  final int gameId;
  final AppDatabase _appDb;

  TableauRepositoryImpl(this._appDb, {required this.gameId});

  @override
  Stream<GameWithPlayers> get watchPlayers =>
      _appDb.gamesDao.watchGameWithPlayers(gameId: gameId);

  @override
  Stream<List<InfoEntryPlayerBean>> get watchInfoEntries =>
      _appDb.gamesDao.watchInfoEntriesInGame(gameId);

  @override
  Stream<Map<String, double>> get watchSums => watchInfoEntries
      .zipWith(watchPlayers, (a, b) => Tuple2(a, b))
      .map((event) => calculateSum(
          event.item1,
          event.item2.players
              .map((e) => PlayerBean.fromDb(e))
              .whereNotNull()
              .toList()));

  @override
  Future<void> addEntry(InfoEntryPlayerBean entry) async {
    _appDb.gamesDao.newEntry(entry, gameId: gameId);
  }
}

final tableauRepositoryProvider =
    Provider.family<TableauRepository, int>((ref, gameId) {
      return TableauRepositoryImpl(ref.watch(databaseProvider), gameId: gameId);
});
