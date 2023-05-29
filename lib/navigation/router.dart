import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/clean_players_screen/clean_players_screen.dart';
import 'package:tagros_comptes/ui/entry_screen/add_modify.dart';
import 'package:tagros_comptes/ui/error_page.dart';
import 'package:tagros_comptes/ui/guide_screen/guide_screen.dart';
import 'package:tagros_comptes/ui/premium_screen/buy_screen.dart';
import 'package:tagros_comptes/ui/screen/menu.dart';
import 'package:tagros_comptes/ui/settings_screen/settings_screen.dart';
import 'package:tagros_comptes/ui/table_screen/tableau.dart';
import 'package:tagros_comptes/ui/theme_screen/theme_screen.dart';

class MyRouter {
  MyRouter();

  final router = GoRouter(
    // refreshListenable: loginState,
    //todo: remove before release
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: MenuScreen.routeName,
        path: MenuScreen.routeName,
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => state.namedLocation(MenuScreen.routeName),
      ),
      GoRoute(
        name: AddModifyEntry.routeName,
        path: '/addModify/:infoEntryId',
        builder: (context, state) {
          final int? id =
              int.tryParse(state.pathParameters['infoEntryId'] ?? '');
          const screen = AddModifyEntry();
          if (id == null) {
            return screen;
          } else {
            return ProviderScope(
              overrides: [selectedInfoEntryIdProvider.overrideWithValue(id)],
              child: screen,
            );
          }
        },
      ),
      GoRoute(
        name: SettingsScreen.routeName,
        path: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        name: ThemeScreen.routeName,
        path: ThemeScreen.routeName,
        builder: (context, state) => const ThemeScreen(),
      ),
      GoRoute(
        name: TableauPage.routeName,
        path: '/game/:gameId',
        builder: (context, state) {
          final int? id = int.tryParse(state.pathParameters['gameId'] ?? '');
          return ProviderScope(
            overrides: [selectedGameIdProvider.overrideWithValue(id)],
            child: const TableauPage(),
          );
        },
      ),
      GoRoute(
        name: BuyScreen.routeName,
        path: BuyScreen.routeName,
        builder: (context, state) => const BuyScreen(),
      ),
      GoRoute(
        name: GuideScreen.routeName,
        path: GuideScreen.routeName,
        builder: (context, state) => const GuideScreen(),
      ),
      GoRoute(
        name: CleanPlayersScreen.routeName,
        path: CleanPlayersScreen.routeName,
        builder: (context, state) => const CleanPlayersScreen(),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),
  );
}

void navigateToGame(BuildContext context, {required int gameId}) {
  context.goNamed(TableauPage.routeName, pathParameters: {'gameId': '$gameId'});
}

void navigateToAddModify(BuildContext context, {required int? infoEntryId}) {
  context.goNamed(AddModifyEntry.routeName,
      pathParameters: {'infoEntryId': '$infoEntryId'});
}
