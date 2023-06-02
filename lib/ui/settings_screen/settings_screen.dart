import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/ui/clean_players_screen/clean_players_screen.dart';
import 'package:tagros_comptes/ui/guide_screen/guide_screen.dart';
import 'package:tagros_comptes/ui/premium_screen/buy_screen.dart';
import 'package:tagros_comptes/ui/theme_screen/theme_screen.dart';
import 'package:tagros_comptes/ui/widget/background_gradient.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).settingsTitle),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(S.of(context).settingsCleanUnusedPlayers),
              onTap: () {
                context.goNamed(CleanPlayersScreen.routeName);
              },
            ),
            ListTile(
              title: Text(S.of(context).settingsGuide),
              onTap: () {
                context.goNamed(GuideScreen.routeName);
              },
            ),
            ListTile(
              title: Text(S.of(context).settingsTheme),
              onTap: () {
                context.goNamed(ThemeScreen.routeName);
              },
            ),
            ListTile(
              title: Text(S.of(context).settingsBuyPremium),
              onTap: () {
                context.goNamed(BuyScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
