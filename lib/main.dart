// import 'package:appspector/appspector.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/model/game/info_entry_player.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:tagros_comptes/services/db/games_dao.dart';
import 'package:tagros_comptes/services/theme/theme_service.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await _runAppSpector();
  if (kDebugMode) {
    // Stetho.initialize();
  }
  await S.load(const Locale('fr'));
  await Hive.initFlutter();
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(ThemeColorAdapter());
  await Hive.openBox(ThemeService.optionsBox);
  await Hive.openBox<ThemeColor>(
    ThemeService.themeBox,
    compactionStrategy: (entries, deletedEntries) => deletedEntries > 20,
  );

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
class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      debugShowMaterialGrid: false,
      title: 'Flutter Demo',
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ref.watch(themeDataProvider).value,
      home: const MenuScreen(),
      routes: <String, WidgetBuilder>{
        MenuScreen.routeName: (context) => const MenuScreen(),
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
    {required GameWithPlayers game, required GamesDao gamesDao}) async {
  if (!game.game.id.present) {
    final idGame = await gamesDao.newGame(game);
    game.game = game.game.copyWith(id: Value(idGame));
  }
  await Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ProviderScope(
        overrides: [gameProvider.overrideWithValue(game)],
        child: const TableauPage()),
  ));
}

Future<InfoEntryPlayerBean?> navigateToAddModify(BuildContext context,
    {required GameWithPlayers game,
    required InfoEntryPlayerBean? infoEntry}) async {
  final modified = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProviderScope(
            overrides: [gameProvider.overrideWithValue(game)],
            child: const AddModifyEntry(),
          ),
      settings:
          RouteSettings(arguments: AddModifyArguments(infoEntry: infoEntry))));
  return modified as InfoEntryPlayerBean?;
}
