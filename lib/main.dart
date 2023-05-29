// import 'package:appspector/appspector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import '.env.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:tagros_comptes/services/theme/theme_service.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  usePathUrlStrategy();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
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
  runApp(const ProviderScope(child: MyApp()));
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
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider.select((value) => value.router));
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
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
    );
  }
}
