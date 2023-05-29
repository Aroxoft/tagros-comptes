import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/game/player.dart';
import 'package:tagros_comptes/navigation/router.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/table_screen/tableau_body.dart';
import 'package:tagros_comptes/ui/widget/background_gradient.dart';

class TableauPage extends ConsumerWidget {
  static const routeName = '/game';

  String routeNameParam(String gameId) => '$routeName/$gameId';

  const TableauPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(currentGameProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
            child: Text(error.toString(),
                style: Theme.of(context).textTheme.titleLarge)),
        data: (game) {
          return BackgroundGradient(
            child: Scaffold(
              appBar: AppBar(
                title: Text(S.current.nbPlayers(game.players.length)),
              ),
              floatingActionButton: FloatingActionButton(
                  // key: ValueKey("${ref.watch(navigationPrefixProvider)}tableau-fab"),
                  heroTag: UniqueKey(),
                  onPressed: () {
                    navigateToAddModify(context, infoEntryId: null);
                  },
                  child: const Icon(Icons.add)),
              body: TableauBody(
                  players: game.players
                      .map((e) => PlayerBean.fromDb(e))
                      .whereNotNull()
                      .toList()),
            ),
          );
        });
  }
}
