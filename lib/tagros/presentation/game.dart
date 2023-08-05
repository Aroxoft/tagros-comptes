import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/presentation/game_view_model.dart';
import 'package:tagros_comptes/tagros/presentation/widget/snack_utils.dart';
import 'package:tagros_comptes/tagros/presentation/widget/tableau_body.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  static const routeName = "/game";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableauVM = ref.watch(tableauViewModelProvider);
    ref.listen(messageObserverProvider, (prev, next) {
      if (next != null) {
        if (kDebugMode) {
          print(next);
        }
        displayFlushbar(context, ref,
            title: next.item1
                ? S.of(context).successAddingGame
                : S.of(context).successModifyingGame,
            message: next.item2.toString());
        ref.read(messageObserverProvider.notifier).state = null;
      }
    });

    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            initialData: 0,
            stream: tableauVM?.nbPlayers,
            builder: (ctx, snapshot) {
              return Text(S.current.nbPlayers(snapshot.data ?? 0));
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () async {
              tableauVM?.navigateToAddModify(context, roundId: null);
            },
            child: const Icon(Icons.add)),
        body: StreamBuilder<List<PlayerBean>>(
            stream: tableauVM?.players,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return TableauBody(players: snapshot.data!);
            }),
      ),
    );
  }
}
