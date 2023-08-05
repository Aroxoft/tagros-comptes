import 'package:flutter/material.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/navigation/routes.dart';

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
              onTap: () => const CleanupRoute().push(context),
            ),
            ListTile(
              title: Text(S.of(context).settingsGuide),
              onTap: () => const GuideRoute().push(context),
            ),
            ListTile(
              title: Text(S.of(context).settingsTheme),
              onTap: () => const ThemeRoute().push(context),
            ),
            ListTile(
              title: Text(S.of(context).settingsBuyPremium),
              onTap: () => const SubscriptionRoute().push(context),
            ),
          ],
        ),
      ),
    );
  }
}
