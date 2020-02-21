import 'dart:collection';

import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';
import 'package:tagros_comptes/calculous/prise.dart';
import 'package:test/test.dart';

void main() {
  var players = ["A", "B", "C", "D"];
  group('Calcul à 4', () {
    test('Petite faite de 0', () {
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
    test("Garde faite de 1", () {
      final entry = InfoEntry(
        player: "C",
        points: 52,
        nbBouts: 1,
        prise: Prise.GARDE,
      );
      expect(calculateGains(entry, players),
          HashMap.from({"A": -52, "B": -52, "C": 52 * 3, "D": -52}));
    });
    test("Garde chutée de 1, points de la défense", () {
      final entry = InfoEntry(
        player: "D",
        points: 51,
        nbBouts: 1,
        pointsForAttack: false,
        prise: Prise.GARDE,
      );
      expect(calculateGains(entry, players),
          HashMap.from({"A": 52, "B": 52, "C": 52, "D": -52 * 3}));
    });
    test("Garde-sans faite de 0", () {
      final entry = InfoEntry(
        player: "A", points: 55, nbBouts: 0, prise: Prise.GARDE_SANS,);
      expect(calculateGains(entry, players),
          HashMap.from({"A": 300, "B": -100, "C": -100, "D": -100}));
    });
  });
}
