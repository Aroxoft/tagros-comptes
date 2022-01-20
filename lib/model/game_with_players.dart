import 'package:tagros_comptes/services/db/database_moor.dart';

class GameWithPlayers {
  Game game;
  List<Player> players;

  GameWithPlayers({required this.players, required this.game});
}
