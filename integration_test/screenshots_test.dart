import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';

import 'common.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const namesEn = ['Mary', 'David', 'Lisa', 'Ronald', 'Sarah'];
  const namesFr = ['Jade', 'David', 'Lisa', 'Raphaël', 'Sarah'];
  group('Taking screenshots', () {
    testWidgets('Player dialog with 5 players en', (t) async {
      await createApp(t, lang: 'en');
      await t.pumpAndSettle();
      await _newGame(t, namesEn);
      for (var i = 0; i < 20; i++) {
        await _addRandomRound(t, namesEn);
      }

      await takeScreenshot(binding, t, screenshotName: '1_en-US');
    });
    testWidgets('Player dialog with 5 players fr', (t) async {
      await createApp(t, lang: 'fr');
      await t.pumpAndSettle();
      await _newGame(t, namesFr);
      for (var i = 0; i < 20; i++) {
        await _addRandomRound(t, namesFr);
      }

      await takeScreenshot(binding, t, screenshotName: '1_fr-FR');
    });

    testWidgets('Edit game en', (t) async {
      await createApp(t, lang: 'en');
      await t.pumpAndSettle();
      final names = namesEn.take(4).toList();
      await _newGame(t, names);

      await _editGame(t, names);
      await takeScreenshot(binding, t,
          screenshotName: '2_en-US', settle: false);
    });

    testWidgets('Edit game fr', (t) async {
      await createApp(t, lang: 'fr');
      await t.pumpAndSettle();
      final names = namesFr.take(4).toList();
      await _newGame(t, names);
      await _editGame(t, names);

      await takeScreenshot(binding, t,
          screenshotName: '2_fr-FR', settle: false);
    });
  });
}

Future<void> _editGame(
  WidgetTester t,
  List<String> names,
) async {
  await t.tap(find.byIcon(Icons.add));
  await t.pumpAndSettle();

  final score = Random().nextInt(91).toString();
  await t.enterText(find.byType(EditableText), score);
  await t.tap(find.byKey(const ValueKey('dropdown-contract')));
  await t.pumpAndSettle();
  await t.tap(find.text(S.current.priseTypeGardeContre));
  await t.pumpAndSettle();
  await t.tap(find.byKey(const ValueKey('dropdown-oudlers')));
  await t.pumpAndSettle();
  await t.tap(find.text('3'));
  await t.pumpAndSettle();
  await t.tap(find.byType(Checkbox).first);
  await t.pumpAndSettle();
  final handful = find.byKey(const ValueKey('dropdown-handful'));
  await t.tap(handful);
  await t.pumpAndSettle();
  await t.tap(find.text(S.current.addModifyPoigneeNbTrumps(
      getNbAtouts(PoigneeType.double, names.length),
      PoigneeType.double.displayName)));
  await t.pump();
}

Future<void> _newGame(WidgetTester tester, List<String> names) async {
  await tester.tap(find.text(S.current.newGame));

  await tester.pumpAndSettle();

  final editText = find.byType(EditableText);
  for (final name in names) {
    await tester.enterText(editText, name);
    await tester.testTextInput.receiveAction(TextInputAction.next);
  }

  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> _addRandomRound(WidgetTester tester, List<String> names) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  var name = names[Random().nextInt(names.length)];
  await tester.dragUntilVisible(
      find.descendant(
          of: find.byKey(const ValueKey('player1')), matching: find.text(name)),
      find.byKey(const ValueKey('player1')),
      const Offset(500, 0));
  await tester.tap(find.text(name).first);
  name = names[Random().nextInt(names.length)];
  await tester.dragUntilVisible(
      find.descendant(
          of: find.byKey(const ValueKey('player2')), matching: find.text(name)),
      find.byKey(const ValueKey('player2')),
      const Offset(500, 0));
  await tester.tap(find.text(name).last);
  final score = Random().nextInt(91).toString();
  await tester.enterText(find.byType(EditableText), score);

  await tester.tap(find.byIcon(Icons.check));
  await tester.pump();
}
