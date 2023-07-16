import 'package:drift/drift.dart';
import 'package:mockito/mockito.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/games_dao.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';
import 'package:tagros_comptes/tagros/domain/repository/tableau_repository.dart';

const _fakePlayers = [
  Player(pseudo: "Alice"),
  Player(pseudo: "Bob"),
  Player(pseudo: "Charline")
];
final _fakeInfoEntries = [
  InfoEntryPlayerBean(
    infoEntry: InfoEntryBean(
      points: 36,
      nbBouts: 3,
      pointsForAttack: true,
    ),
    player: PlayerBean(name: "Alice"),
  ),
  InfoEntryPlayerBean(
    infoEntry: InfoEntryBean(
      points: 55,
      nbBouts: 2,
      prise: Prise.garde,
      pointsForAttack: true,
    ),
    player: PlayerBean(name: "Bob"),
  ),
];
final fakeGameWithPlayers = GameWithPlayers(
  game: const GamesCompanion(id: Value(1)),
  players: _fakePlayers,
);

class FakeGamesDao extends Fake implements GamesDao {
  FakeGamesDao();

  @override
  Stream<List<InfoEntryPlayerBean>> watchInfoEntriesInGame(int gameId) {
    return Stream.value(_fakeInfoEntries);
  }

  @override
  Stream<GameWithPlayers> watchGameWithPlayers({required int gameId}) {
    return Stream.value(GameWithPlayers(
        players: _fakePlayers,
        game: GamesCompanion(
            id: Value(gameId),
            nbPlayers: Value(_fakePlayers.length),
            date: Value(DateTime.now()))));
  }
}

class FakeRepository extends Fake implements TableauRepository {
  @override
  Stream<List<InfoEntryPlayerBean>> get watchInfoEntries =>
      Stream.value(_fakeInfoEntries);

  @override
  Stream<GameWithPlayers> get watchPlayers => Stream.value(fakeGameWithPlayers);

  @override
  Stream<Map<String, double>> get watchSums => Stream.value({
        _fakePlayers[0].pseudo: 20,
        _fakePlayers[1].pseudo: 30,
        _fakePlayers[2].pseudo: -50,
      });
}
