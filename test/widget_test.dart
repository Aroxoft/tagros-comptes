// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/dialog/dialog_players.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/services/db/platforms/database.dart';
import 'package:tagros_comptes/widget/choose_player.dart';

void main() {
  testWidgets('Show dialog players', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: DialogPlayerBody(
            doAfterChosen: (players) {
              if (kDebugMode) {
                print(players);
              }
            },
          ),
        ),
      ),
    ));
    final finder = find.text('Aa');
    expect(finder, findsNothing);
  });

  testWidgets('Choose player test', (WidgetTester tester) async {
    final db = MyDatabase(Database.openConnection());
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(
      child: Material(
        child: AutocompleteFormField(
          ["Aa", "Bb", "CC", "Dd"]
              .map((e) => Player(id: null, pseudo: e))
              .toList(),
          initialValue: Player(pseudo: "Aa", id: null),
          validator: (value) => null,
          onSaved: (Player? newValue) {},
          database: db,
        ),
      ),
    ));

    final finder = find.text("Aa");
    expect(finder, findsOneWidget);

//    // Tap the '+' icon and trigger a frame.
//    await tester.tap(find.byIcon(Icons.add));
//    await tester.pump();
//
//    // Verify that our counter has incremented.
//    expect(find.text('0'), findsNothing);
//    expect(find.text('1'), findsOneWidget);
  });
}
