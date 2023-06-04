import 'dart:async';

import 'package:tagros_comptes/services/db/games_dao.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';

class GameNotifier {
  final _deleteGameController = StreamController<GameWithPlayers>.broadcast();
  final GamesDao _gamesDao;

  StreamSink<GameWithPlayers> get inDeleteGame => _deleteGameController.sink;

  GameNotifier({required GamesDao gamesDao}) : _gamesDao = gamesDao {
    _deleteGameController.stream.listen(_handleDeleteGame);
  }

  void dispose() {
    _deleteGameController.close();
  }

  Future<void> _handleDeleteGame(GameWithPlayers event) async {
    await _gamesDao.deleteGame(event);
  }
}
