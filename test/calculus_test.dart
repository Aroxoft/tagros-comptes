import 'dart:collection';

import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';
import 'package:tagros_comptes/calculous/prise.dart';
import 'package:test/test.dart';

void main() {
  var players = ["A", "B", "C", "D"];
  group('Calcul à 4', () {
    test('Simple case is not correct', () {
      final entry = InfoEntry(
          points: 36,
          pointsForAttack: true,
          nbBouts: 3,
          player: "A",
          prise: Prise.PETITE);
      expect(calculateGains(entry, players),
          HashMap.from({"A": 25 * 3, "B": -25, "C": -25, "D": -25}));
    });
    test('Petite chutée de 3', () {
      final entry = InfoEntry(
        player: "B",
        points: 48,
        nbBouts: 1,
      );
      expect(calculateGains(entry, players),
          HashMap.from({"A": 28, "B": -28 * 3, "C": 28, "D": 28}));
    });
  });
}
