import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/screen/add_modify.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/widget/tableau_body.dart';

class TableauPage extends ConsumerWidget {
  const TableauPage({Key? key, required this.game}) : super(key: key);
  final GameWithPlayers game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${game.players.length} joueurs"),
      ),
      floatingActionButton: FloatingActionButton(
          foregroundColor: Colors.pink,
          onPressed: () async {
            final res = await Navigator.of(context).pushNamed(
                AddModifyEntry.routeName,
                arguments:
                    AddModifyArguments(players: game.players, infoEntry: null));
            if (res != null) {
              final info = res as InfoEntryPlayerBean;
              ref
                  .read(entriesProvider)
                  .inAddEntry
                  .add(info);
              Flushbar(
                flushbarStyle: FlushbarStyle.GROUNDED,
                flushbarPosition: FlushbarPosition.BOTTOM,
                title: "Partie ajoutée avec succès",
                duration: const Duration(seconds: 2),
                message: info.toString(),
                backgroundGradient: const LinearGradient(
                  colors: [Colors.blueGrey, Colors.teal],
                ),
              ).show(context);
              if (kDebugMode) {
                print(info);
              }
            }
          },
          child: const Icon(Icons.add)),
      body: TableauBody(
          players: game.players
              .map((e) => PlayerBean.fromDb(e))
              .whereNotNull()
              .toList()),
    );
  }
}
