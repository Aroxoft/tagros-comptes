import 'dart:collection';

import 'package:tagros_comptes/calculous/camp.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';
import 'package:tagros_comptes/calculous/poignee.dart';
import 'package:tagros_comptes/calculous/prise.dart';

HashMap<String, int> calculateGains(
    InfoEntry infoEntry, HashSet<String> players) {
  // Assert that players in entry exist in the list of players
  assert(players.contains(infoEntry.player));
  if (infoEntry.withPlayers != null) {
    for (var withPlayer in infoEntry.withPlayers) {
      assert(players.contains(withPlayer));
    }
  }

  var nbPlayers = players.length;
  var gros = nbPlayers > 5;
  var totalPoints = 91;
  int nbBouts;
  if (gros) {
    totalPoints *= 2;
  }
  var pointsForAttack = infoEntry.pointsForAttack
      ? infoEntry.points
      : totalPoints - infoEntry.points;
  int wonBy;
  if (!gros) {
    switch (infoEntry.nbBouts) {
      case 0:
        wonBy = pointsForAttack - 56;
        break;
      case 1:
        wonBy = pointsForAttack - 51;
        break;
      case 2:
        wonBy = pointsForAttack - 41;
        break;
      case 3:
        wonBy = pointsForAttack - 36;
        break;
    }
  } else {
    switch (infoEntry.nbBouts) {
      case 0:
        wonBy = pointsForAttack - 112;
        break;
      case 1:
        wonBy = pointsForAttack - 102;
        break;
      case 2:
        wonBy = pointsForAttack - 82;
        break;
      case 3:
        wonBy = pointsForAttack - 72;
        break;
      case 4:
        wonBy = pointsForAttack - 102;
        break;
      case 5:
        wonBy = pointsForAttack - 102;
        break;
      case 6:
        wonBy = pointsForAttack - 102;
        break;
    }
  }

  bool won = wonBy >= 0;
  // Petit au bout
  int petitPoints = 0;
  for (var petitAuBout in infoEntry.petitsAuBout) {
    switch (petitAuBout) {
      case Camp.ATTACK:
        petitPoints += won ? 10 : -10;
        break;
      case Camp.DEFENSE:
        petitPoints += won ? -10 : 10;
        break;
      case Camp.NONE:
        break;
    }
  }

  // Poignee
  var pointsForPoignee = 0;
  for (var poignee in infoEntry.poignees) {
    pointsForPoignee += getPoigneePoints(poignee);
  }

  int mise = (wonBy.abs() + 25 + petitPoints) * getCoeff(infoEntry.prise) +
      pointsForPoignee;

  var res = HashMap<String, int>();
  if(!gros) {

  }

  return res;
}
