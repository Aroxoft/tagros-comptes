import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/dialog/dialog_games.dart';
import 'package:tagros_comptes/dialog/dialog_players.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/screen/test_native.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/types/functions.dart';
class MenuScreen extends StatelessWidget {
  static const routeName = "/menu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).appTitle),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context).pushNamed(TestNative.routeName);
                })
          ],
        ),
        body: const MenuBody());
  }
}

class MenuBody extends StatelessWidget {
  const MenuBody({Key? key}) : super(key: key);

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
                      appDatabase: ref.read(databaseProvider),
                      game: GameWithPlayers(
                          game: Game(
                              id: null,
                              nbPlayers: players.length,
                              date: DateTime.now()),
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

  void showDialogPlayers(BuildContext context, {required DoAfterChosen doAfter}) {
    showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return DialogChoosePlayers(doAfterChosen: doAfter);
        });
  }
}
