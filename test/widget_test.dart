// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/theme/data/source/theme_dao.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';
import 'package:tagros_comptes/theme/domain/theme_repository.dart';

void main() {
  testWidgets('Go to settings smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await S.load(const Locale('en'));

    await tester.pumpWidget(Localizations(
      locale: const Locale('en'),
      delegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: ProviderScope(
        overrides: [
          themeRepositoryProvider.overrideWithValue(
            _FakeThemeRepository(),
          ),
          databaseProvider.overrideWith((ref) => _FakeAppDatabase()),
          bannerAdsProvider.overrideWith((ref, arg) => Future.error('')),
        ],
        child: const MyApp(),
      ),
    ));
    await tester.pumpAndSettle();

    // Verify that our counter starts at 0.
    expect(find.text('New game'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Settings'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    final icon = find.byIcon(Icons.settings);
    await tester.tap(icon);
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);

    expect(find.text('New game'), findsNothing);
    expect(find.text('Continue'), findsNothing);
  });
}

class _FakeAppDatabase extends Fake implements AppDatabase {
  @override
  ThemeDao get themeDao => _FakeThemeDao();
}

class _FakeThemeDao extends Fake implements ThemeDao {
  @override
  Stream<ThemeDb?> watchSelectedTheme() =>
      Stream.value(ThemeColor.defaultTheme().toDbTheme);
}

class _FakeThemeRepository extends Fake implements ThemeRepository {
  @override
  Stream<ThemeData> get themeData =>
      Stream.value(ThemeColor.defaultTheme().toDataTheme);
}
