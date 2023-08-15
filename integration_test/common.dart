import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/monetization/domain/premium_plan.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';
import 'package:tagros_comptes/theme/domain/theme_repository.dart';
import 'package:universal_platform/universal_platform.dart';

Future<void> createApp(WidgetTester widgetTester,
    {String lang = 'en', ThemeColor? themeColor}) async {
  await S.load(Locale(lang));

  await widgetTester.pumpWidget(ProviderScope(
    overrides: [
      themeRepositoryProvider.overrideWithValue(
        _FakeThemeRepository(themeColor: themeColor),
      ),
      databaseProvider.overrideWith((ref) {
        final appDatabase = AppDatabase(NativeDatabase.memory());
        ref.onDispose(() {
          appDatabase.close();
        });
        return appDatabase;
      }),
      isPremiumProvider.overrideWith((ref) => true),
      showAdsProvider.overrideWith((ref) => ShowAds.hide),
      bannerAdsProvider.overrideWith((ref, arg) => Future.error('')),
    ],
    child: MyApp(locale: Locale(lang)),
  ));
}

/// Take a screenshot of the current screen.
/// Cannot take more than one screenshot per test.
Future<void> takeScreenshot(
  IntegrationTestWidgetsFlutterBinding binding,
  WidgetTester tester, {
  required int screenshotNumber,
  bool settle = true,
  required String locale,
  DeviceType deviceType = DeviceType.phone,
}) async {
  if (UniversalPlatform.isAndroid) {
    await binding.convertFlutterSurfaceToImage();
    if (settle) {
      await tester.pumpAndSettle();
    }
  }
  await binding
      .takeScreenshot('${screenshotNumber}_${locale}_${deviceType.folderName}');
}

enum DeviceType {
  phone("phoneScreenshots"),
  sevenInchTablet("sevenInchScreenshots"),
  tenInchTablet("tenInchScreenshots"),
  tv("tvScreenshots"),
  wearable("wearScreenshots");

  final String folderName;

  const DeviceType(this.folderName);
}

class _FakeThemeRepository extends Fake implements ThemeRepository {
  final ThemeColor _themeColor;

  _FakeThemeRepository({ThemeColor? themeColor})
      : _themeColor = themeColor ?? ThemeColor.defaultTheme();

  @override
  Stream<ThemeData> get themeData => Stream.value(_themeColor.toDataTheme);

  @override
  Stream<ThemeColor> selectedTheme() {
    return Future.value(ThemeColor.defaultTheme()).asStream();
  }

  @override
  Stream<List<ThemeColor>> allThemes() {
    return Future.value(ThemeColor.allThemes).asStream();
  }

  @override
  Future<void> selectTheme({required int id}) async {}
}
