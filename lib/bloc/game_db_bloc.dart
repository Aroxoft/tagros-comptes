import 'dart:async';

import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/model/game_with_players.dart';

class GameDbBloc implements BlocBase {
  final _deleteGameController = StreamController<GameWithPlayers>.broadcast();

  StreamSink<GameWithPlayers> get inDeleteGame => _deleteGameController.sink;

  GameDbBloc() {
    _deleteGameController.stream.listen(_handleDeleteGame);
  }

  @override
  void dispose() {
    _deleteGameController.close();
  }

  void _handleDeleteGame(GameWithPlayers event) async {
    await MyDatabase.db.deleteGame(event);
  }
}
