import 'package:flutter/material.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/prise.dart';

class InfoEntryPlayerBean {
  PlayerBean player;
  List<PlayerBean> withPlayers;
  InfoEntryBean infoEntry;
  InfoEntryPlayerBean(
      {@required this.player, @required this.infoEntry, this.withPlayers});

  @override
  String toString() {
    String campDesPoints =
        infoEntry.pointsForAttack ? "l'attaque" : "la défense";
    return "${getNomPrise(infoEntry.prise)} de $player${withPlayers != null && withPlayers.length > 0 ? " (avec ${withPlayers[0]}${withPlayers.length == 2 ? " et ${withPlayers[1]}" : ""}" : ""}, ${infoEntry.points} points pour $campDesPoints, ${infoEntry.nbBouts} bout(s) pour $campDesPoints.";
  }
}
