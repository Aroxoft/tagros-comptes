import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:patrol/patrol.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/theme/data/source/theme_dao.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';
import 'package:tagros_comptes/theme/domain/theme_repository.dart';

const _patrolTesterConfig = PatrolTesterConfig();
const _nativeAutomatorConfig = NativeAutomatorConfig(
  packageName: 'com.aroxoft.tagros.points',
  bundleId: 'com.aroxoft.tagros.points',
  findTimeout: Duration(seconds: 20),
);

Future<void> createApp(PatrolTester $) async {
  await S.load(const Locale('en'));

  await $.pumpWidget(Localizations(
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
}

void patrol(
  String description,
  Future<void> Function(PatrolTester $) callback, {
  bool? skip,
  NativeAutomatorConfig? nativeAutomatorConfig,
  LiveTestWidgetsFlutterBindingFramePolicy framePolicy =
      LiveTestWidgetsFlutterBindingFramePolicy.fadePointers,
}) {
  patrolTest(
      description,
      config: _patrolTesterConfig,
      nativeAutomatorConfig: nativeAutomatorConfig ?? _nativeAutomatorConfig,
      nativeAutomation: true,
      framePolicy: framePolicy,
      skip: skip,
      callback);
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

  @override
  Stream<ThemeColor> selectedTheme() {
    return Future.value(ThemeColor.defaultTheme()).asStream();
  }

  @override
  Stream<List<ThemeColor>> allThemes() {
    return Future.value([ThemeColor.defaultTheme(), ThemeColor.chocolate()])
        .asStream();
  }

  @override
  Future<void> selectTheme({required int id}) async {}


}
