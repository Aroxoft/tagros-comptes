import 'package:flutter/cupertino.dart';

class Player {
  int id;
  String name;

  Player({@required this.name, this.id});

  factory Player.fromJson(Map<String, dynamic> json) =>
      Player(
          name: json["name"],
          id: json["id"]
      );

  Map<String, dynamic> toJson() =>
      {
        "name": name,
        "id": id,
      };
}
