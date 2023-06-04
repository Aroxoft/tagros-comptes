import 'package:flutter/material.dart';
import 'package:tagros_comptes/common/presentation/clean_players_screen.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/common/presentation/guide_screen.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/monetization/presentation/buy_screen.dart';
import 'package:tagros_comptes/theme/presentation/theme_screen.dart';

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
                Navigator.of(context).pushNamed(CleanPlayersScreen.routeName);
              },
            ),
            ListTile(
              title: Text(S.of(context).settingsGuide),
              onTap: () {
                Navigator.of(context).pushNamed(GuideScreen.routeName);
              },
            ),
            ListTile(
              title: Text(S.of(context).settingsTheme),
              onTap: () {
                Navigator.of(context).pushNamed(ThemeScreen.routeName);
              },
            ),
            ListTile(
              title: Text(S.of(context).settingsBuyPremium),
              onTap: () {
                Navigator.of(context).pushNamed(BuyScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
