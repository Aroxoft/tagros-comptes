import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:tagros_comptes/common/presentation/clean_players_screen.dart';
import 'package:tagros_comptes/common/presentation/guide_screen.dart';
import 'package:tagros_comptes/common/presentation/menu.dart';
import 'package:tagros_comptes/common/presentation/settings_screen.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/monetization/presentation/buy_screen.dart';
import 'package:tagros_comptes/tagros/presentation/add_modify.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';
import 'package:tagros_comptes/theme/presentation/theme_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await S.load(const Locale('fr'));
  await Hive.initFlutter();

  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  runApp(const ProviderScope(child: MyApp()));
  FlutterError.demangleStackTrace = (StackTrace stackTrace) {
    if (stackTrace is stack_trace.Trace) return stackTrace.vmTrace;
    if (stackTrace is stack_trace.Chain) return stackTrace.toTrace().vmTrace;
    return stackTrace;
  };
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

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
