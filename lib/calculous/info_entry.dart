import 'package:flutter/material.dart';
import 'package:tagros_comptes/calculous/camp.dart';
import 'package:tagros_comptes/calculous/poignee.dart';
import 'package:tagros_comptes/calculous/prise.dart';

class InfoEntry {
  static int allId = 0;
  final int id;
  String player;
  List<String> withPlayers;
  Prise prise;
  int points;
  int nbBouts;

  /// are the points for the attack?
  bool pointsForAttack;
  List<Camp> petitsAuBout;
  List<PoigneeType> poignees;

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
