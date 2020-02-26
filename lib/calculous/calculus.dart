import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';

Map<String, double> calculateGains(InfoEntry infoEntry,
    List<String> players) {
  // Assert that players in entry exist in the list of players
  assert(players.contains(infoEntry.player));
  if (infoEntry.withPlayers != null) {
    for (var withPlayer in infoEntry.withPlayers) {
      assert(players.contains(withPlayer));
    }
  }

  var nbPlayers = players.length;

  if (nbPlayers > 5) {
    assert (infoEntry.withPlayers.length == 2);
  } else if (nbPlayers == 5) {
    assert (infoEntry.withPlayers.length == 1);
  }

  var gros = nbPlayers > 5;
  var totalPoints = 91;
  var totalBouts = 3;
  if (gros) {
    totalPoints *= 2;
    totalBouts *= 2;
  }
  var pointsForAttack = infoEntry.pointsForAttack
      ? infoEntry.points
      : totalPoints - infoEntry.points;
  var boutsForAttack = infoEntry.pointsForAttack
      ? infoEntry.nbBouts
      : totalBouts - infoEntry.nbBouts;
  double wonBy;
  if (!gros) {
    switch (boutsForAttack) {
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
        wonBy = pointsForAttack - 106;
        break;
      case 1:
        wonBy = pointsForAttack - 101;
        break;
      case 2:
        wonBy = pointsForAttack - 96;
        break;
      case 3:
        wonBy = pointsForAttack - 91;
        break;
      case 4:
        wonBy = pointsForAttack - 86;
        break;
      case 5:
        wonBy = pointsForAttack - 81;
        break;
      case 6:
        wonBy = pointsForAttack - 75;
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

  double mise = (wonBy.abs() + 25 + petitPoints) * getCoeff(infoEntry.prise) +
      pointsForPoignee;
  if (!won) mise = -mise;

  var gains = Map<String, double>();
  // init gains to 0
  for (var player in players) {
    gains[player] = 0;
  }

  if (!gros) {
    if (nbPlayers < 5 || infoEntry.player == infoEntry.withPlayers[0]) {
      // one player against the others
      for (var player in players) {
        gains[player] =
        infoEntry.player == player ? mise * (nbPlayers - 1) : -mise;
      }
    } else {
      // with 5 players, 2 vs 3
      for (var player in players) {
        if (player == infoEntry.player) {
          gains[player] = mise * 2;
        } else if (player == infoEntry.withPlayers[0]) {
          gains[player] = mise;
        } else {
          gains[player] = -mise;
        }
      }
    }
  } else {
    // TAGROS
    // Common for every tagros
    for (var player in players) {
      if (player == infoEntry.player) {
        // taker
        gains[player] = mise * 2;
      } else if (infoEntry.withPlayers.contains(player)) {
        // Attackers with taker
        gains[player] = mise;
      } else {
        gains[player] = -mise * 4 / (nbPlayers - 3);
      }
    }
  }

  return gains;
}

double checkSum(Map<String, double> gains) {
  double sum = 0;
  for (var entry in gains.entries) {
    sum += entry.value;
  }
  return sum;
}

Map<String, double> calculateSum(List<InfoEntry> entries,
    List<String> players) {
  Map<String, double> sums = {};
  for (var player in players) {
    sums[player] = 0;
  }

  for (var entry in entries) {
    var gains = calculateGains(entry, players);
    for (var gain in gains.entries) {
      sums[gain.key] += gain.value;
    }
  }
  return sums;
}

List<double> transformGainsToList(Map<String, double> gains,
    List<String> players) {
  var res = List<double>(players.length);
  for (int i = 0; i < players.length; i++) {
    res[i] = gains[players[i]];
  }

  return res;
}
