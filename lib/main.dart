import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/navigation/router_listenable.dart';
import 'package:tagros_comptes/navigation/routes.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';
import 'package:tagros_comptes/util/state_logger.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await S.load(const Locale('fr'));

  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());
  usePathUrlStrategy();
  runApp(const ProviderScope(
    observers: [StateLogger()],
    child: MyApp(),
  ));
  FlutterError.demangleStackTrace = (StackTrace stackTrace) {
    if (stackTrace is stack_trace.Trace) return stackTrace.vmTrace;
    if (stackTrace is stack_trace.Chain) return stackTrace.toTrace().vmTrace;
    return stackTrace;
  };
}

@immutable
class MyApp extends HookConsumerWidget {
  final Locale? locale;

  const MyApp({super.key, this.locale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(routerListenableProvider.notifier);
    final key = useRef(GlobalKey<NavigatorState>(debugLabel: 'routerKey'));
    final router = useMemoized(
      () => GoRouter(
          navigatorKey: key.value,
          refreshListenable: notifier,
          initialLocation: HomeRoute.path,
          debugLogDiagnostics: true,
          routes: $appRoutes,
          redirect: notifier.redirect),
      [notifier],
    );
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      debugShowMaterialGrid: false,
      onGenerateTitle: (context) => S.of(context).appTitle,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: locale,
      theme: ref.watch(themeDataProvider).valueOrNull,
    );
  }
}
