import 'package:flutter/cupertino.dart';
import 'package:tagros_comptes/data/database_moor.dart';

class PlayerBean {
  int id;
  String name;

  PlayerBean({@required this.name, this.id});

  factory PlayerBean.fromDb(Player player) {
    if (player == null) return null;
    return PlayerBean(name: player.pseudo, id: player.id);
  }

  @override
  String toString() {
    return "$name ($id)";
  }

  static Player toDb(PlayerBean player) {
    if (player == null) return null;
    return Player(pseudo: player.name, id: player.id);
  }
}
