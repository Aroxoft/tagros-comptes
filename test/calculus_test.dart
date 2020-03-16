import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/prise.dart';
import 'package:test/test.dart';

void main() {
  group('Calcul à 4', () {
    var players = ["A", "B", "C", "D"].map((e) => PlayerBean(name: e)).toList();
    final A = PlayerBean(name: "A");
    final B = PlayerBean(name: "B");
    final C = PlayerBean(name: "C");
    final D = PlayerBean(name: "D");

    InfoEntryPlayerBean entry;
    Map<String, double> gains;

    test('Petite faite de 0 (3 bouts)', () {
      entry = InfoEntryPlayerBean(
          player: A,
          infoEntry: InfoEntryBean(
            prise: Prise.PETITE,
            nbBouts: 3,
            points: 36,
            pointsForAttack: true,
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": 25 * 3, "B": -25, "C": -25, "D": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Petite faite de 0 (2 bouts)', () {
      entry = InfoEntryPlayerBean(
          player: A,
          infoEntry: InfoEntryBean(
            prise: Prise.PETITE,
            points: 41,
            pointsForAttack: true,
            nbBouts: 2,
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": 25 * 3, "B": -25, "C": -25, "D": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Petite faite de 0 (1 bout)', () {
      entry = InfoEntryPlayerBean(
          player: A,
          infoEntry: InfoEntryBean(
            prise: Prise.PETITE,
            points: 51,
            pointsForAttack: true,
            nbBouts: 1,
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": 25 * 3, "B": -25, "C": -25, "D": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Petite faite de 0 (0 bouts)', () {
      entry = InfoEntryPlayerBean(
          player: A,
          infoEntry: InfoEntryBean(
            prise: Prise.PETITE,
            points: 56,
            pointsForAttack: true,
            nbBouts: 0,
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": 25 * 3, "B": -25, "C": -25, "D": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });

    test('Petite chutée de 3 (1 bout)', () {
      entry = InfoEntryPlayerBean(
        player: B,
        infoEntry: InfoEntryBean(
          points: 48,
          nbBouts: 1,
        ),
      );
      gains = calculateGains(entry, players);
      expect(gains, {"A": 28, "B": -28 * 3, "C": 28, "D": 28});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test("Garde faite de 1", () {
      entry = InfoEntryPlayerBean(
        player: C,
        infoEntry: InfoEntryBean(
          points: 52,
          nbBouts: 1,
          prise: Prise.GARDE,
        ),
      );
      gains = calculateGains(entry, players);
      expect(gains, {"A": -52, "B": -52, "C": 52 * 3, "D": -52});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test("Garde chutée de 1, points de la défense", () {
      entry = InfoEntryPlayerBean(
        player: D,
        infoEntry: InfoEntryBean(
          points: 51,
          nbBouts: 1,
          pointsForAttack: false,
          prise: Prise.GARDE,
        ),
      );
      gains = calculateGains(entry, players);
      expect(gains, {"A": 52, "B": 52, "C": 52, "D": -52 * 3});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test("Garde-sans faite de 0", () {
      entry = InfoEntryPlayerBean(
        player: A,
        infoEntry: InfoEntryBean(
          points: 56,
          nbBouts: 0,
          prise: Prise.GARDE_SANS,
        ),
      );
      gains = calculateGains(entry, players);
      expect(gains, {"A": 300, "B": -100, "C": -100, "D": -100});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test("Garde faite de 0, petit au bout attaque", () {
      entry = InfoEntryPlayerBean(
          player: A,
          infoEntry: InfoEntryBean(
            points: 36,
            nbBouts: 3,
            prise: Prise.GARDE,
            petitsAuBout: [Camp.ATTACK],
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": 70 * 3, "B": -70, "C": -70, "D": -70});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
  });
  group('Calcul à 5', () {
    var players =
        ["A", "B", "C", "D", "E"].map((e) => PlayerBean(name: e)).toList();
    final A = PlayerBean(name: "A");
    final B = PlayerBean(name: "B");
    final C = PlayerBean(name: "C");
    final D = PlayerBean(name: "D");
    final E = PlayerBean(name: "E");

    InfoEntryPlayerBean entry;
    Map<String, double> gains;

    test('Petite de A, appel de B, faite de 0', () {
      entry = InfoEntryPlayerBean(
          player: A,
          withPlayers: [B],
          infoEntry: InfoEntryBean(
            points: 36,
            nbBouts: 3,
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": 50, "B": 25, "C": -25, "D": -25, "E": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Petite de A, appel de B, chutée de 3 (1 bout)', () {
      entry = InfoEntryPlayerBean(
          player: A,
          withPlayers: [B],
          infoEntry: InfoEntryBean(
            points: 48,
            nbBouts: 1,
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": -56, "B": -28, "C": 28, "D": 28, "E": 28});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Garde de D, appel de C, faite de 0 (2 bouts)', () {
      entry = InfoEntryPlayerBean(
          player: D,
          withPlayers: [C],
          infoEntry: InfoEntryBean(
            points: 41,
            nbBouts: 2,
            prise: Prise.GARDE,
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": -50, "B": -50, "C": 50, "D": 100, "E": -50});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
    test('Garde-sans de C, tout seul, faite de 0 (3 bouts)', () {
      entry = InfoEntryPlayerBean(
          player: C,
          withPlayers: [C],
          infoEntry: InfoEntryBean(
            prise: Prise.GARDE_SANS,
            points: 36,
            nbBouts: 3,
          ));
      gains = calculateGains(entry, players);
      expect(gains, {"A": -100, "B": -100, "C": 400, "D": -100, "E": -100});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
  });
  group('Calcul à 7', () {
    final A = PlayerBean(name: "A");
    final B = PlayerBean(name: "B");
    final C = PlayerBean(name: "C");
    final D = PlayerBean(name: "D");
    final E = PlayerBean(name: "E");
    final F = PlayerBean(name: "F");
    final G = PlayerBean(name: "G");
    final players = [A, B, C, D, E, F, G];
    InfoEntryPlayerBean entry;
    Map<String, double> gains;

    test('Petite de A, appel de B et C, faite de 0 (0 bouts)', () {
      entry = InfoEntryPlayerBean(
          player: A,
          withPlayers: [B, C],
          infoEntry: InfoEntryBean(
            points: 106,
            nbBouts: 0,
          ));
      gains = calculateGains(entry, players);
      expect(gains,
          {"A": 50, "B": 25, "C": 25, "D": -25, "E": -25, "F": -25, "G": -25});
      expect(checkSum(gains), 0, reason: "Failed checksum");
    });
  });
}
