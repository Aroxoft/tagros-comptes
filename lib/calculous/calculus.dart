import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';

Map<String, double> calculateGains(
    InfoEntryPlayerBean infoEntryPlayer, List<PlayerBean> playersList) {
  final players = playersList.map((e) => e.name).toList();
  // Assert that players in entry exist in the list of players
  assert(players.contains(infoEntryPlayer.player.name));
  if (infoEntryPlayer.withPlayers != null) {
    for (var withPlayer in infoEntryPlayer.withPlayers) {
      assert(players.contains(withPlayer.name));
    }
  }

  var nbPlayers = players.length;

  if (nbPlayers > 5) {
    assert(infoEntryPlayer.withPlayers.length == 2);
  } else if (nbPlayers == 5) {
    assert(infoEntryPlayer.withPlayers.length == 1);
  }

  var gros = nbPlayers > 5;
  var totalPoints = 91;
  var totalBouts = 3;
  if (gros) {
    totalPoints *= 2;
    totalBouts *= 2;
  }
  var pointsForAttack = infoEntryPlayer.infoEntry.pointsForAttack
      ? infoEntryPlayer.infoEntry.points
      : totalPoints - infoEntryPlayer.infoEntry.points;
  var boutsForAttack = infoEntryPlayer.infoEntry.pointsForAttack
      ? infoEntryPlayer.infoEntry.nbBouts
      : totalBouts - infoEntryPlayer.infoEntry.nbBouts;
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
    switch (infoEntryPlayer.infoEntry.nbBouts) {
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
  if (infoEntryPlayer.infoEntry.petitsAuBout != null) {
    for (var petitAuBout in infoEntryPlayer.infoEntry.petitsAuBout) {
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
  }

  // Poignee
  var pointsForPoignee = 0;
  if (infoEntryPlayer.infoEntry.poignees != null) {
    for (var poignee in infoEntryPlayer.infoEntry.poignees) {
      pointsForPoignee += getPoigneePoints(poignee);
    }
  }

  double mise = (wonBy.abs() + 25 + petitPoints) *
          getCoeff(infoEntryPlayer.infoEntry.prise) +
      pointsForPoignee;
  if (!won) mise = -mise;

  var gains = Map<String, double>();
  // init gains to 0
  for (var player in players) {
    gains[player] = 0;
  }

  if (!gros) {
    if (nbPlayers < 5 ||
        infoEntryPlayer.player == infoEntryPlayer.withPlayers[0]) {
      // one player against the others
      for (var player in players) {
        gains[player] = infoEntryPlayer.player.name == player
            ? mise * (nbPlayers - 1)
            : -mise;
      }
    } else {
      // with 5 players, 2 vs 3
      for (var player in players) {
        if (player == infoEntryPlayer.player.name) {
          gains[player] = mise * 2;
        } else if (player == infoEntryPlayer.withPlayers[0].name) {
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
      if (player == infoEntryPlayer.player.name) {
        // taker
        gains[player] = mise * 2;
      } else if (infoEntryPlayer.withPlayers.contains(player)) {
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

Map<String, double> calculateSum(
    List<InfoEntryPlayerBean> entries, List<PlayerBean> players) {
  Map<String, double> sums = {};
  for (var player in players) {
    sums[player.name] = 0;
  }

  for (var entry in entries) {
    var gains = calculateGains(entry, players);
    for (var gain in gains.entries) {
      sums[gain.key] += gain.value;
    }
  }
  return sums;
}

List<double> transformGainsToList(
    Map<String, double> gains, List<PlayerBean> players) {
  var res = List<double>(players.length);
  for (int i = 0; i < players.length; i++) {
    res[i] = gains[players[i].name];
  }

  return res;
}
