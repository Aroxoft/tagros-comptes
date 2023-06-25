import 'package:flutter/foundation.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/players_dao.dart';

class CleanPlayersVM extends ChangeNotifier {
  CleanPlayersVM(PlayersDao playersDao)
      : _playersDao = playersDao,
        unusedPlayers = playersDao.unusedPlayers().watch();
  final Stream<List<Player>> unusedPlayers;
  final PlayersDao _playersDao;

  Future<int> deleteAllUnused() {
    return _playersDao.deleteAllUnused();
  }

  Future<void> deletePlayer({required int? idPlayer}) {
    return _playersDao.deletePlayer(idPlayer);
  }
}
