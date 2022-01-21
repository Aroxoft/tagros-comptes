import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/nb_players.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/types/functions.dart';
import 'package:tagros_comptes/widget/choose_player.dart';
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

class DialogPlayerBody extends ConsumerStatefulWidget {
  final DoAfterChosen doAfterChosen;

  const DialogPlayerBody({Key? key, required this.doAfterChosen})
      : super(key: key);

  @override
  _DialogPlayerBodyState createState() => _DialogPlayerBodyState();
}

class _DialogPlayerBodyState extends ConsumerState<DialogPlayerBody> {
  late List<Player> players;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    players = [];
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
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
                              setState(() {
                                if (players.contains(newValue)) {
                                  errorMessage = S.of(context).errorSameName;
                                  return;
                                }
                                if (newValue == null ||
                                    newValue.pseudo.isEmpty) {
                                  errorMessage = S.of(context).errorPseudoEmpty;
                                  return;
                                }
                                errorMessage = null;
                                players.add(newValue);
                              });
                            },
                            initialValue: Player(id: null, pseudo: ""),
                            validator: (value) {
                              final nbPlayers = players.length;
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
                                players.length,
                                (index) => Chip(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      elevation: 20,
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      padding: EdgeInsets.zero,
                                      label: Text(players[index].pseudo),
                                      backgroundColor: Colors.pink,
                                      deleteIcon: const Icon(Icons.delete),
                                      deleteButtonTooltipMessage:
                                          S.of(context).dialogPlayersDelete,
                                      deleteIconColor: Colors.white,
                                      onDeleted: () {
                                        setState(() {
                                          players.removeAt(index);
                                        });
                                      },
                                    )),
                          ),
                          if (errorMessage != null)
                            Text(
                              errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            )
                        ]),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop();
                        widget.doAfterChosen(players);
                      }
                    },
                    child: Text(S.of(context).ok))
              ]);
        },
      ),
    );
  }
}
