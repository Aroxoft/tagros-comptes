import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/common/presentation/dialog/dialog_games.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/navigation/routes.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/presentation/dialog/dialog_players.dart';

class HomeScreen extends HookConsumerWidget {
  static const routeName = "/menu";
  final bool _showAds;

  const HomeScreen({super.key, bool showAds = true}) : _showAds = showAds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appTitle),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => const SettingsRoute().push(context))
          ],
        ),
        body: Column(
          children: [
            const Expanded(child: MenuBody()),
            if (_showAds)
              ref
                  .watch(bannerAdsProvider(
                      MediaQuery.of(context).size.width.truncate()))
                  .when(
                      data: (ad) => SizedBox(
                          width: ad.size.width.toDouble(),
                          height: ad.size.height.toDouble(),
                          child: AdWidget(ad: ad)),
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () => const CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class MenuBody extends StatelessWidget {
  const MenuBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Consumer(
          builder: (context, ref, child) => ElevatedButton(
            onPressed: () {
              showDialogPlayers(context);
            },
            child: Text(S.of(context).newGame),
          ),
        ),
        ElevatedButton(
            child: Text(S.of(context).toContinue),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => const DialogChooseGame(),
              );
            })
      ],
    ));
  }

  void showDialogPlayers(BuildContext context) {
    showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const DialogChoosePlayers();
        });
  }
}
