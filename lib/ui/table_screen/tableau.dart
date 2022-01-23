import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game/player.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/table_screen/tableau_body.dart';
import 'package:tagros_comptes/ui/widget/background_gradient.dart';

class TableauPage extends ConsumerWidget {
  const TableauPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.nbPlayers(game.players.length)),
        ),
        floatingActionButton: FloatingActionButton(
            // key: ValueKey("${ref.watch(navigationPrefixProvider)}tableau-fab"),
            heroTag: UniqueKey(),
            onPressed: () async {
              final info =
                  await navigateToAddModify(context, game: game, infoEntry: null);
              if (info != null) {
                ref.read(entriesProvider).inAddEntry.add(info);
                Flushbar(
                  flushbarStyle: FlushbarStyle.GROUNDED,
                  flushbarPosition: FlushbarPosition.BOTTOM,
                  title: S.of(context).successAddingGame,
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
      ),
    );
  }
}
