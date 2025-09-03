import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tagros_comptes/tagros/data/game_provider.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/games_dao.dart';
import 'package:tagros_comptes/tagros/domain/calculus.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/repository/tableau_repository.dart';
import 'package:tuple/tuple.dart';

part 'tableau_repository_impl.g.dart';

class TableauRepositoryImpl implements TableauRepository {
  final int gameId;
  final GamesDao _gamesDao;

  TableauRepositoryImpl(this._gamesDao, {required this.gameId});

  @override
  Stream<GameWithPlayers> get watchPlayers =>
      _gamesDao.watchGameWithPlayers(gameId: gameId);

  @override
  Stream<List<InfoEntryPlayerBean>> get watchInfoEntries =>
      _gamesDao.watchInfoEntriesInGame(gameId);

  @override
  Stream<Map<String, double>> get watchSums => watchInfoEntries
      .zipWith(watchPlayers, (a, b) => Tuple2(a, b))
      .map((event) => calculateSum(
          event.item1,
          event.item2.players
              .map((e) => PlayerBean.fromDb(e))
              .nonNulls
              .toList()));

  @override
  Future<void> addEntry(InfoEntryPlayerBean entry) async {
    _gamesDao.newEntry(entry, gameId: gameId);
  }

  @override
  Future<void> modifyEntry(InfoEntryPlayerBean entry) async {
    _gamesDao.updateEntry(entry, gameId: gameId);
  }

  @override
  Future<void> deleteEntry(int entryId) async {
    _gamesDao.deleteEntry(entryId, gameId: gameId);
  }
}

@Riverpod(keepAlive: true, dependencies: [CurrentGameId, gamesDao])
TableauRepository? tableauRepository(Ref ref) {
  final gamesDao = ref.watch(gamesDaoProvider);
  return ref.watch(currentGameIdProvider.select((value) => value.whenOrNull(
        data: (gameId) {
          return TableauRepositoryImpl(gamesDao, gameId: gameId);
        },
      )));
}
