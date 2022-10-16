import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/types/functions.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/widget/choose_player.dart';

class DialogChoosePlayers extends ConsumerWidget {
  final DoAfterChosen doAfterChosen;

  const DialogChoosePlayers({super.key, required this.doAfterChosen});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: DialogPlayerBody(
        doAfterChosen: doAfterChosen,
      ),
      actions: <Widget>[
        // error display
        if (ref
            .watch(choosePlayerProvider.select((value) => value.error != null)))
          Text(ref.watch(choosePlayerProvider.select((value) => value.error!)),
              style: const TextStyle(color: Colors.red)),
        ElevatedButton(
            onPressed: () {
              if (ref.read(choosePlayerProvider).validatePlayers()) {
                doAfterChosen(ref.read(choosePlayerProvider).selectedPlayers);
                Navigator.of(context).pop();
              }
            },
            child: Text(S.of(context).ok))
      ],
    );
  }
}

class DialogPlayerBody extends HookConsumerWidget {
  const DialogPlayerBody({super.key, required this.doAfterChosen});
  final DoAfterChosen doAfterChosen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ChoosePlayer(),
            Wrap(
              direction: Axis.horizontal,
              spacing: 8,
              runSpacing: -6,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: List.generate(
                  ref.watch(
                      choosePlayerProvider.select((value) => value.nbPlayers)),
                  (index) => Chip(
                        label: Text(
                          ref.watch(choosePlayerProvider.select(
                              (value) => value.selectedPlayers[index].pseudo)),
                        ),
                        deleteIcon: const Icon(Icons.delete),
                        deleteButtonTooltipMessage:
                            S.of(context).dialogPlayersDelete,
                        onDeleted: () => ref
                            .read(choosePlayerProvider)
                            .removePlayerAt(index: index),
                      )),
            ),
          ]),
    );
  }
}
