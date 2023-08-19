import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
            ListTile(
              title: Text(S.of(context).settingsAbout),
              onTap: () async {
                final version = (await PackageInfo.fromPlatform()).version;
                if (context.mounted) {
                  showAboutDialog(
                    context: context,
                    applicationVersion: version,
                    applicationIcon: Image.asset(
                      'images/logo_small.png',
                      width: 64,
                      height: 64,
                    ),
                    applicationName: S.of(context).appTitle,
                    applicationLegalese: '© 2023 Tagros',
                  );

                }
              },
            ),
            ListTile(
              title: Center(
                child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (ctx, snap) {
                    if (snap.hasError) return const SizedBox.shrink();
                    if (!snap.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final PackageInfo info = snap.data!;
                    return Text(
                      S.of(context).appVersion(
                          info.appName, info.version, info.buildNumber),
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
