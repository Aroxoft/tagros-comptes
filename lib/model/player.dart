import 'package:tagros_comptes/services/db/app_database.dart';

class PlayerBean {
  int? id;
  String name;

  PlayerBean({required this.name, this.id});

  static PlayerBean? fromDb(Player? player) {
    if (player == null) return null;
    return PlayerBean(name: player.pseudo, id: player.id);
  }

  @override
  String toString() {
    return "$name ($id)";
  }

  Player get toDb => Player(pseudo: name, id: id);
}
