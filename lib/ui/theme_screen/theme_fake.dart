import 'package:mockito/mockito.dart';
import 'package:tagros_comptes/model/game/info_entry.dart';
import 'package:tagros_comptes/model/game/info_entry_player.dart';
import 'package:tagros_comptes/model/game/player.dart';
import 'package:tagros_comptes/model/game/prise.dart';
import 'package:tagros_comptes/services/db/games_dao.dart';

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
