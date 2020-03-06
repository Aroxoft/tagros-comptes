import 'package:flutter/cupertino.dart';
import 'package:tagros_comptes/model/player.dart';

class Game {
  int id;
  int nbPlayers;
  DateTime dateTime;
  List<Player> players;

  Game(
      {@required this.nbPlayers,
      this.dateTime,
      this.id,
        this.players});

  factory Game.fromJson(Map<String, dynamic> json) => Game(
        nbPlayers: json["nbPlayers"],
        id: json["id"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nbPlayers": nbPlayers,
        "dateTime": dateTime.millisecondsSinceEpoch
      };
}
