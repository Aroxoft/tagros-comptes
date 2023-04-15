import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/model/types/functions.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/dialog/dialog_games.dart';
import 'package:tagros_comptes/ui/dialog/dialog_players.dart';
import 'package:tagros_comptes/ui/settings_screen/settings_screen.dart';
import 'package:tagros_comptes/ui/widget/background_gradient.dart';

class MenuScreen extends HookConsumerWidget {
  static const routeName = "/menu";
  final bool _showAds;

  const MenuScreen({super.key, bool showAds = true}) : _showAds = showAds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appTitle),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                })
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
              showDialogPlayers(context,
                  doAfter: (players) => navigateToTableau(context,
                      gamesDao: ref.read(gamesDaoProvider),
                      game: GameWithPlayers(
                          game: GamesCompanion.insert(
                              nbPlayers: players.length, date: DateTime.now()),
                          players: players)));
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

  void showDialogPlayers(BuildContext context,
      {required DoAfterChosen doAfter}) {
    showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return DialogChoosePlayers(doAfterChosen: doAfter);
        });
  }
}
