import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'common.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('smoke testing', () {
    testWidgets('go to themes screen smoke test', (t) async {
      await createApp(t);

      expect(find.text('New game'), findsOneWidget);

      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Settings'), findsNothing);

      await t.tap(find.byIcon(Icons.settings));
      await t.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);

      expect(find.text('New game'), findsNothing);
      expect(find.text('Continue'), findsNothing);

      await t.tap(find.text('Theme'));
      await t.pumpAndSettle();

      expect(find.text('Classic'), findsOneWidget);
      expect(find.text('Chocolate'), findsOneWidget);

      await t.tap(find.text('Chocolate'));

      expect(find.text('Chocolate'), findsOneWidget);
      expect(find.text('Classic'), findsOneWidget);
    });
  });
}
