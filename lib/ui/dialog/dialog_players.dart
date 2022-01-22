import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/nb_players.dart';
import 'package:tagros_comptes/model/types/functions.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/widget/choose_player.dart';

class DialogChoosePlayers extends StatelessWidget {
  final DoAfterChosen doAfterChosen;

  const DialogChoosePlayers({Key? key, required this.doAfterChosen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: DialogPlayerBody(
        doAfterChosen: doAfterChosen,
      ),
//      actions: <Widget>[
//        FlatButton(
//            onPressed: () {
//              if (formKey.currentState.validate()) {
//                Navigator.of(context).pop();
//                doAfterChosen(players);
//              }
//            },
//            child: Text("OK"))
//      ],
    );
  }
}

class DialogPlayerBody extends HookConsumerWidget {
  const DialogPlayerBody({Key? key, required this.doAfterChosen})
      : super(key: key);
  final DoAfterChosen doAfterChosen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = useState(<Player>[]);
    final errorMessage = useState<String?>(null);
    final formKey = useState(GlobalKey<FormState>());
    return Form(
      key: formKey.value,
      child: StreamBuilder<List<Player>>(
        stream: ref.watch(databaseProvider).watchAllPlayers,
        builder: (BuildContext context, AsyncSnapshot<List<Player>> snapshot) {
          List<Player> playerDb = [];
          if (!snapshot.hasError && snapshot.hasData && snapshot.data != null) {
            playerDb = snapshot.data!;
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutocompleteFormField(
                            playerDb,
                            onSaved: (newValue) {
                              if (players.value.contains(newValue)) {
                                errorMessage.value =
                                    S.of(context).errorSameName;
                                return;
                              }
                              if (newValue == null || newValue.pseudo.isEmpty) {
                                errorMessage.value =
                                    S.of(context).errorPseudoEmpty;
                                return;
                              }
                              errorMessage.value = null;
                              final newPlayers = players.value.toList();
                              newPlayers.add(newValue);
                              players.value = newPlayers;
                            },
                            initialValue: Player(id: null, pseudo: ""),
                            validator: (value) {
                              final nbPlayers = players.value.length;
                              if (!NbPlayers.values
                                  .map((e) => e.number)
                                  .contains(nbPlayers)) {
                                return S
                                    .of(context)
                                    .errorGameNbPlayers(nbPlayers);
                              }
                              return null;
                            },
                            database: ref.watch(databaseProvider),
                          ),
                          Wrap(
                            direction: Axis.horizontal,
                            spacing: 2,
                            runSpacing: 3,
                            alignment: WrapAlignment.spaceEvenly,
                            children: List.generate(
                                players.value.length,
                                (index) => Chip(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      elevation: 8,
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      padding: EdgeInsets.zero,
                                      label: Text(players.value[index].pseudo),
                                      backgroundColor: Colors.pink,
                                      deleteIcon: const Icon(Icons.delete),
                                      deleteButtonTooltipMessage:
                                          S.of(context).dialogPlayersDelete,
                                      deleteIconColor: Colors.white,
                                      onDeleted: () {
                                        final newPlayers =
                                            players.value.toList();
                                        newPlayers.removeAt(index);
                                        players.value = newPlayers;
                                      },
                                    )),
                          ),
                          if (errorMessage.value != null)
                            Text(
                              errorMessage.value!,
                              style: const TextStyle(color: Colors.red),
                            )
                        ]),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.value.currentState?.validate() ?? false) {
                        Navigator.of(context).pop();
                        doAfterChosen(players.value);
                      }
                    },
                    child: Text(S.of(context).ok))
              ]);
        },
      ),
    );
  }
}
