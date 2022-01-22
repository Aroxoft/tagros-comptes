import 'dart:async';

import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/services/db/app_database.dart';

class GameNotifier {
  final _deleteGameController = StreamController<GameWithPlayers>.broadcast();
  final AppDatabase _database;

  StreamSink<GameWithPlayers> get inDeleteGame => _deleteGameController.sink;

  GameNotifier({required AppDatabase database}) : _database = database {
    _deleteGameController.stream.listen(_handleDeleteGame);
  }

  void dispose() {
    _deleteGameController.close();
  }

  Future<void> _handleDeleteGame(GameWithPlayers event) async {
    await _database.deleteGame(event);
  }
}
