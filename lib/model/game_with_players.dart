import 'package:tagros_comptes/services/db/app_database.dart';

class GameWithPlayers {
  Game game;
  List<Player> players;

  GameWithPlayers({required this.players, required this.game});
}
