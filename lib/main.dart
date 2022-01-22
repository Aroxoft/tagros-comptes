// import 'package:appspector/appspector.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/clean_players_screen/clean_players_screen.dart';
import 'package:tagros_comptes/ui/entry_screen/add_modify.dart';
import 'package:tagros_comptes/ui/guide_screen/guide_screen.dart';
import 'package:tagros_comptes/ui/premium_screen/buy_screen.dart';
import 'package:tagros_comptes/ui/screen/menu.dart';
import 'package:tagros_comptes/ui/settings_screen/settings_screen.dart';
import 'package:tagros_comptes/ui/table_screen/tableau.dart';
import 'package:tagros_comptes/ui/theme_screen/theme_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
// import '.env.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await _runAppSpector();
  if (kDebugMode) {
    // Stetho.initialize();
  }
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  runApp(ProviderScope(child: MyApp()));
}

/*
Future<void> _runAppSpector() async {
  var config = Config()
        ..androidApiKey = environment['appSpector']
        ..iosApiKey = environment['appSpectorIos']
      // ..monitors = [Monitors.sqLite, Monitors.fileSystem]
      ;
  AppSpectorPlugin.run(config);

  await AppSpectorPlugin.shared().start();
  AppSpectorPlugin.shared().sessionUrlListener = (url) => print(url);
}
// */
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  onPrimary: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10)))),
      home: MenuScreen(),
      routes: <String, WidgetBuilder>{
        MenuScreen.routeName: (context) => MenuScreen(),
        AddModifyEntry.routeName: (context) => const AddModifyEntry(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        ThemeScreen.routeName: (context) => const ThemeScreen(),
        BuyScreen.routeName: (context) => const BuyScreen(),
        GuideScreen.routeName: (context) => const GuideScreen(),
        CleanPlayersScreen.routeName: (context) => const CleanPlayersScreen(),
      },
    );
  }
}

Future<void> navigateToTableau(BuildContext context,
    {required GameWithPlayers game, required AppDatabase appDatabase}) async {
  if (game.game.id == null) {
    final idGame = await appDatabase.newGame(game);
    game.game = game.game.copyWith(id: Value(idGame));
  }
  await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ProviderScope(
        overrides: [gameProvider.overrideWithValue(game)],
        child: TableauPage(game: game)),
  ));
}
