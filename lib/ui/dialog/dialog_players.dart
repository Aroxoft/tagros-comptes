import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/types/functions.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/widget/choose_player.dart';

class DialogChoosePlayers extends ConsumerWidget {
  final DoAfterChosen doAfterChosen;

  const DialogChoosePlayers({Key? key, required this.doAfterChosen})
      : super(key: key);

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
  const DialogPlayerBody({Key? key, required this.doAfterChosen})
      : super(key: key);
  final DoAfterChosen doAfterChosen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeColorProvider).value;
    return SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ChoosePlayer(),
            Wrap(
              direction: Axis.horizontal,
              spacing: 2,
              runSpacing: 3,
              alignment: WrapAlignment.spaceEvenly,
              children: List.generate(
                  ref.watch(
                      choosePlayerProvider.select((value) => value.nbPlayers)),
                  (index) => Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        elevation: 8,
                        labelStyle: TextStyle(color: theme?.chipTextColor),
                        padding: EdgeInsets.zero,
                        label: Text(
                          ref.watch(choosePlayerProvider.select(
                              (value) => value.selectedPlayers[index].pseudo)),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: theme?.chipTextColor),
                        ),
                        backgroundColor: theme?.chipColor,
                        deleteIcon: const Icon(Icons.delete),
                        deleteButtonTooltipMessage:
                            S.of(context).dialogPlayersDelete,
                        deleteIconColor: theme?.chipTextColor,
                        onDeleted: () {
                          ref
                              .read(choosePlayerProvider)
                              .removePlayerAt(index: index);
                        },
                      )),
            ),
          ]),
    );
  }
}
