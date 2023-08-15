import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagros_comptes/common/presentation/clean_players_screen.dart';
import 'package:tagros_comptes/common/presentation/error_page.dart';
import 'package:tagros_comptes/common/presentation/guide_screen.dart';
import 'package:tagros_comptes/common/presentation/menu.dart';
import 'package:tagros_comptes/common/presentation/settings_screen.dart';
import 'package:tagros_comptes/monetization/presentation/subscription_screen.dart';
import 'package:tagros_comptes/tagros/presentation/game.dart';
import 'package:tagros_comptes/tagros/presentation/new_add_modify.dart';
import 'package:tagros_comptes/theme/presentation/theme_screen.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(path: HomeRoute.path)
class HomeRoute extends GoRouteData {
  const HomeRoute();

  static const path = '/home';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return HomeScreen(key: state.pageKey);
  }
}

@TypedGoRoute<SettingsRoute>(path: SettingsRoute.path)
class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  static const path = '/settings';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SettingsScreen(key: state.pageKey);
  }
}

@TypedGoRoute<ThemeRoute>(path: ThemeRoute.path)
class ThemeRoute extends GoRouteData {
  const ThemeRoute();

  static const path = '/theme';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ThemeScreen(key: state.pageKey);
  }
}

@TypedGoRoute<GuideRoute>(path: GuideRoute.path)
class GuideRoute extends GoRouteData {
  const GuideRoute();

  static const path = '/guide';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GuideScreen(key: state.pageKey);
  }
}

@TypedGoRoute<SubscriptionRoute>(path: SubscriptionRoute.path)
class SubscriptionRoute extends GoRouteData {
  const SubscriptionRoute();

  static const path = '/subscription';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SubscriptionScreen(key: state.pageKey);
  }
}

@TypedGoRoute<CleanupRoute>(path: CleanupRoute.path)
class CleanupRoute extends GoRouteData {
  const CleanupRoute();

  static const path = '/cleanup';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CleanPlayersScreen(key: state.pageKey);
  }
}

@TypedGoRoute<GameRoute>(path: GameRoute.path)
class GameRoute extends GoRouteData {
  const GameRoute();

  static const path = '/game';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return GameScreen(key: state.pageKey);
  }
}

@TypedGoRoute<EntryRoute>(path: EntryRoute.path)
class EntryRoute extends GoRouteData {
  const EntryRoute(this.roundId);

  final int? roundId;

  static const path = '/round';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NewAddModify(key: state.pageKey, roundId: roundId);
  }
}

@TypedGoRoute<ErrorRoute>(path: ErrorRoute.path)
class ErrorRoute extends GoRouteData {
  const ErrorRoute();

  static const path = '/error';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ErrorScreen(message: state.error.toString());
  }
}
