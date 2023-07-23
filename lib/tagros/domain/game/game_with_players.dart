import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';

class GameWithPlayers {
  GamesCompanion game;
  List<Player> players;

  GameWithPlayers({required this.players, required this.game});
}
