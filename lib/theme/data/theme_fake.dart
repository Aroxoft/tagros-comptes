import 'package:mockito/mockito.dart';
import 'package:tagros_comptes/tagros/data/source/db/games_dao.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';

class FakeGamesDao extends Fake implements GamesDao {
  @override
  Stream<List<InfoEntryPlayerBean>> watchInfoEntriesInGame(int gameId) {
    return Stream.value([
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
    ]);
  }
}
