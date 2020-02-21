import 'package:flutter/material.dart';
import 'package:tagros_comptes/calculous/camp.dart';
import 'package:tagros_comptes/calculous/poignee.dart';
import 'package:tagros_comptes/calculous/prise.dart';

class InfoEntry {
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
    ], this.poignees = const []});
}
