import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/game.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';

class InfoEntry {
  int id;
  Player player;
  List<Player> withPlayers;
  Prise prise;
  double points;
  int nbBouts;

  /// are the points for the attack?
  bool pointsForAttack;
  List<Camp> petitsAuBout;
  List<PoigneeType> poignees;

  static Future<InfoEntry> fromJson(Map<String, dynamic> json,
      DBProvider dbProvider) async {
    var player = await dbProvider.getPlayer(json["player"]);
    var with1 = await dbProvider.getPlayer(json["with1"]);
    var with2 = await dbProvider.getPlayer(json["with2"]);
    List<Player> withP = [with1, with2]
      ..retainWhere((element) =>
      element != null);
    var petitsAuBout = json["petitsAuBout"];
    var poignees = json["poignee"];
    return InfoEntry(
      id: json["id"],
      player: player,
      withPlayers: withP,
      petitsAuBout: fromDbPetit(petitsAuBout),
      poignees: fromDbPoignee(poignees),
      prise: fromDbPrise(json["prise"]),
        points: json["points"],
        nbBouts: json["nbBouts"],);
  }

  Map<String, dynamic> toJson(Game game) =>
      {
        "id": id,
        "game": game.id,
        "player": player.id,
        "with1": withPlayers != null && withPlayers.length > 0 ? withPlayers[0]
            .id : null,
        "with2": withPlayers != null && withPlayers.length > 1 ? withPlayers[1]
            .id : null,
        "points": points,
        "petitAuBout": toDbPetits(petitsAuBout),
        "poignee": toDbPoignees(poignees),
        "nbBouts": nbBouts,
        "prise": toDbPrise(prise)
      };

  InfoEntry({@required this.player, this.withPlayers, this.prise = Prise
      .PETITE, @required this.points,
    @required this.nbBouts, this.pointsForAttack = true, this.petitsAuBout = const[
    ], this.poignees = const [], this.id});

  @override
  String toString() {
    String campDesPoints = pointsForAttack ? "l'attaque" : "la défense";
    return "${getNomPrise(
        prise)} de $player${withPlayers != null && withPlayers.length > 0
        ? " (avec ${withPlayers[0]}${withPlayers.length == 2
        ? " et ${withPlayers[1]}" : ""}"
        : ""}, $points points pour $campDesPoints, $nbBouts bout(s) pour $campDesPoints.";
  }
}
