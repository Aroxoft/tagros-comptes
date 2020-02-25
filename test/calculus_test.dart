import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/calculous/camp.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';
import 'package:tagros_comptes/calculous/prise.dart';
import 'package:test/test.dart';

void main() {
  group('Calcul à 4', () {
    var players = ["A", "B", "C", "D"];
    InfoEntry entry;
    Map<String, double> gains;

    test('Petite faite de 0 (3 bouts)', () {
      entry = InfoEntry(
          points: 36,
          pointsForAttack: true,
          nbBouts: 3,
          player: "A",
          prise: Prise.PETITE);
      gains = calculateGains(entry, players);
      expect(gains, {"A": 25 * 3, "B": -25, "C": -25, "D": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Petite faite de 0 (2 bouts)', () {
      entry = InfoEntry(
          points: 41,
          pointsForAttack: true,
          nbBouts: 2,
          player: "A",
          prise: Prise.PETITE);
      gains = calculateGains(entry, players);
      expect(gains, {"A": 25 * 3, "B": -25, "C": -25, "D": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Petite faite de 0 (1 bout)', () {
      entry = InfoEntry(
          points: 51,
          pointsForAttack: true,
          nbBouts: 1,
          player: "A",
          prise: Prise.PETITE);
      gains = calculateGains(entry, players);
      expect(gains, {"A": 25 * 3, "B": -25, "C": -25, "D": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Petite faite de 0 (0 bouts)', () {
      entry = InfoEntry(
          points: 56,
          pointsForAttack: true,
          nbBouts: 0,
          player: "A",
          prise: Prise.PETITE);
      gains = calculateGains(entry, players);
      expect(gains, {"A": 25 * 3, "B": -25, "C": -25, "D": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });

    test('Petite chutée de 3 (1 bout)', () {
      entry = InfoEntry(
        player: "B",
        points: 48,
        nbBouts: 1,
      );
      gains = calculateGains(entry, players);
      expect(gains, {"A": 28, "B": -28 * 3, "C": 28, "D": 28});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test("Garde faite de 1", () {
      entry = InfoEntry(
        player: "C",
        points: 52,
        nbBouts: 1,
        prise: Prise.GARDE,
      );
      gains = calculateGains(entry, players);
      expect(gains, {"A": -52, "B": -52, "C": 52 * 3, "D": -52});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test("Garde chutée de 1, points de la défense", () {
      entry = InfoEntry(
        player: "D",
        points: 51,
        nbBouts: 1,
        pointsForAttack: false,
        prise: Prise.GARDE,
      );
      gains = calculateGains(entry, players);
      expect(gains, {"A": 52, "B": 52, "C": 52, "D": -52 * 3});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test("Garde-sans faite de 0", () {
      entry = InfoEntry(
        player: "A", points: 56, nbBouts: 0, prise: Prise.GARDE_SANS,);
      gains = calculateGains(entry, players);
      expect(gains, {"A": 300, "B": -100, "C": -100, "D": -100});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test("Garde faite de 0, petit au bout attaque", () {
      entry = InfoEntry(player: "A",
          points: 36,
          nbBouts: 3,
          prise: Prise.GARDE,
          petitsAuBout: [Camp.ATTACK]);
      gains = calculateGains(entry, players);
      expect(gains, {"A": 70 * 3, "B": -70, "C": -70, "D": -70});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
  });
  group('Calcul à 5', () {
    var players = ["A", "B", "C", "D", "E"];
    InfoEntry entry;
    Map<String, double> gains;

    test('Petite de A, appel de B, faite de 0', () {
      entry =
          InfoEntry(player: 'A', points: 36, nbBouts: 3, withPlayers: ['B']);
      gains = calculateGains(entry, players);
      expect(gains, {"A": 50, "B": 25, "C": -25, "D": -25, "E": -25});
    });
    test('Petite de A, appel de B, chutée de 3 (1 bout)', () {
      entry =
          InfoEntry(player: 'A', points: 48, nbBouts: 1, withPlayers: ['B']);
      gains = calculateGains(entry, players);
      expect(gains, {"A": -56, "B": -28, "C": 28, "D": 28, "E": 28});
    });
    test('Garde de D, appel de C, faite de 0 (2 bouts)', () {
      entry =
          InfoEntry(player: 'D',
              points: 41,
              nbBouts: 2,
              withPlayers: ['C'],
              prise: Prise.GARDE);
      gains = calculateGains(entry, players);
      expect(gains, {"A": -50, "B": -50, "C": 50, "D": 100, "E": -50});
    });
    test('Garde-sans de C, tout seul, faite de 0 (3 bouts)', () {
      entry =
          InfoEntry(player: 'C',
              points: 36,
              nbBouts: 3,
              withPlayers: ['C'],
              prise: Prise.GARDE_SANS);
      gains = calculateGains(entry, players);
      expect(gains, {"A": -100, "B": -100, "C": 400, "D": -100, "E": -100});
    });
  });
}
