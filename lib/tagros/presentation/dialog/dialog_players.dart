import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/player_search_field.dart';
import 'package:tagros_comptes/common/presentation/navigation.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/data/game_provider.dart';
import 'package:tagros_comptes/tagros/presentation/dialog/choose_player_view_model.dart';

class DialogChoosePlayers extends ConsumerWidget {
  const DialogChoosePlayers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(S.of(context).dialogNewGameTitle),
      content: const DialogPlayerBody(),
      actions: <Widget>[
        // error display
        ref.watch(choosePlayerProvider.select((value) {
          final error = value.$1;
          if (error != null) {
            return Text(error, style: const TextStyle(color: Colors.red));
          } else {
            return const SizedBox();
          }
        })),
        OutlinedButton(
          onPressed: () => context.pop(),
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
            onPressed: () {
              if (ref.read(choosePlayerProvider.notifier).validatePlayers()) {
                context.pop();
                navigateToTableau(context);
                ref.read(currentGameIdProvider.notifier).setGame(
                    CurrentGameConstructorNewGame(
                        ref.read(choosePlayerProvider).$2));
              }
            },
            child: Text(S.of(context).ok)),
      ],
    );
  }
}

class DialogPlayerBody extends HookConsumerWidget {
  const DialogPlayerBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choosePlayerVM = ref.watch(choosePlayerProvider.notifier);
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PlayerSearchField(
            onAdd: (name) {
              choosePlayerVM.addPlayerByName(name);
            },
            onSelected: (player) {
              choosePlayerVM.addPlayer(player);
            },
            searchForPlayer: (query) =>
                choosePlayerVM.updateSuggestions(query: query),
          ),
          Wrap(
            direction: Axis.horizontal,
            spacing: 8,
            runSpacing: -6,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: List.generate(
                ref.watch(
                    choosePlayerProvider.select((value) => value.$2.length)),
                (index) => Chip(
                      label: Text(
                        ref.watch(choosePlayerProvider
                            .select((value) => value.$2[index].pseudo)),
                      ),
                      deleteIcon: const Icon(Icons.delete),
                      deleteButtonTooltipMessage:
                          S.of(context).dialogPlayersDelete,
                      onDeleted: () =>
                          choosePlayerVM.removePlayerAt(index: index),
                    )),
          ),
        ]);
  }
}
