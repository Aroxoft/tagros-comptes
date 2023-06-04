import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';

Map<String, double> calculateGains(
    InfoEntryPlayerBean infoEntryPlayer, List<PlayerBean> playersList) {
  final players = playersList.map((e) => e.name).toList();
  // Assert that players in entry exist in the list of players
  assert(players.contains(infoEntryPlayer.player!.name));
  if (infoEntryPlayer.withPlayers != null) {
    for (final withPlayer in infoEntryPlayer.withPlayers!) {
      assert(players.contains(withPlayer!.name));
    }
  }

  final nbPlayers = players.length;

  if (nbPlayers > 5) {
    assert(infoEntryPlayer.withPlayers?.length == 2);
  } else if (nbPlayers == 5) {
    assert(infoEntryPlayer.withPlayers?.length == 1);
  }

  final gros = nbPlayers > 5;
  var totalPoints = 91;
  var totalBouts = 3;
  if (gros) {
    totalPoints *= 2;
    totalBouts *= 2;
  }
  final pointsForAttack = infoEntryPlayer.infoEntry.pointsForAttack
      ? infoEntryPlayer.infoEntry.points
      : totalPoints - infoEntryPlayer.infoEntry.points;
  final boutsForAttack = infoEntryPlayer.infoEntry.pointsForAttack
      ? infoEntryPlayer.infoEntry.nbBouts
      : totalBouts - infoEntryPlayer.infoEntry.nbBouts;
  double wonBy = 0;
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

  final bool won = wonBy >= 0;
  // Petit au bout
  int petitPoints = 0;
  for (final petitAuBout in infoEntryPlayer.infoEntry.petitsAuBout) {
    switch (petitAuBout) {
      case Camp.attack:
        petitPoints += won ? 10 : -10;
        break;
      case Camp.defense:
        petitPoints += won ? -10 : 10;
        break;
      case Camp.none:
        break;
    }
  }

  // Poignee
  var pointsForPoignee = 0;
  for (final poignee in infoEntryPlayer.infoEntry.poignees) {
    pointsForPoignee += getPoigneePoints(poignee);
  }

  double mise =
      (wonBy.abs() + 25 + petitPoints) * infoEntryPlayer.infoEntry.prise.coeff +
          pointsForPoignee;
  if (!won) mise = -mise;

  final gains = <String, double>{};
  // init gains to 0
  for (final player in players) {
    gains[player] = 0;
  }

  if (!gros) {
    if (nbPlayers < 5 ||
        infoEntryPlayer.player == infoEntryPlayer.withPlayers![0]) {
      // one player against the others
      for (final player in players) {
        gains[player] = infoEntryPlayer.player!.name == player
            ? mise * (nbPlayers - 1)
            : -mise;
      }
    } else {
      // with 5 players, 2 vs 3
      for (final player in players) {
        if (player == infoEntryPlayer.player!.name) {
          gains[player] = mise * 2;
        } else if (player == infoEntryPlayer.withPlayers![0]!.name) {
          gains[player] = mise;
        } else {
          gains[player] = -mise;
        }
      }
    }
  } else {
    // TAGROS
    // Common for every tagros
    for (final player in players) {
      if (player == infoEntryPlayer.player!.name) {
        // taker
        gains[player] = mise * 2;
      } else if (infoEntryPlayer.withPlayers!
          .map((e) => e!.name)
          .contains(player)) {
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
  for (final entry in gains.entries) {
    sum += entry.value;
  }
  return sum;
}

Map<String, double> calculateSum(
    List<InfoEntryPlayerBean> entries, List<PlayerBean> players) {
  final Map<String, double> sums = {};
  for (final player in players) {
    sums[player.name] = 0;
  }

  for (final entry in entries) {
    final gains = calculateGains(entry, players);
    for (final gain in gains.entries) {
      sums[gain.key] = sums[gain.key]! + gain.value;
    }
  }
  return sums;
}

List<double> transformGainsToList(
        Map<String, double> gains, List<PlayerBean> players) =>
    List.generate(players.length, (index) => gains[players[index].name]!);
