import 'package:flutter/cupertino.dart';
import 'package:tagros_comptes/data/database_moor.dart';

class PlayerBean {
  int id;
  String name;

  PlayerBean({@required this.name, this.id});

  factory PlayerBean.fromDb(Player player) =>
      PlayerBean(name: player.pseudo, id: player.id);

  factory PlayerBean.fromJson(Map<String, dynamic> json) =>
      PlayerBean(name: json["name"], id: json["id"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };

  @override
  String toString() {
    return "$name ($id)";
  }
}
