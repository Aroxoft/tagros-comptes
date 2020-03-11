import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database_moor.dart';

class GameWithPlayers {
  int id;
  int nbPlayers;
  DateTime dateTime;
  List<Player> players;

  GameWithPlayers(
      {@required this.nbPlayers, this.dateTime, this.id, this.players});

  Game toGameDb() => Game(id: id, nbPlayers: nbPlayers, date: dateTime);
}
