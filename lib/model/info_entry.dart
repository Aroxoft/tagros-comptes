import 'package:flutter/material.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';

class InfoEntry {
  static int allId = 0;
  final int id;
  String player;
  List<String> withPlayers;
  Prise prise;
  double points;
  int nbBouts;

  /// are the points for the attack?
  bool pointsForAttack;
  List<Camp> petitsAuBout;
  List<PoigneeType> poignees;

  factory InfoEntry.fromJson(Map<String, dynamic> json) =>
      InfoEntry(player: json["player"],
        points: json["points"],
        nbBouts: json["nbBouts"],);

  Map<String, dynamic> toJson() =>
      {
        "player": player,
        "points": points,
        "nbBouts": nbBouts,
        "prise": prise.toString()
      };

  InfoEntry({@required this.player, this.withPlayers, this.prise = Prise
      .PETITE, @required this.points,
    @required this.nbBouts, this.pointsForAttack = true, this.petitsAuBout = const[
    ], this.poignees = const []}) : this.id = allId {
    allId++;
  }

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
