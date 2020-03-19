import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/model/nb_players.dart';
import 'package:tagros_comptes/types/functions.dart';
import 'package:tagros_comptes/widget/choose_player.dart';

class DialogChoosePlayers extends StatelessWidget {
  final DoAfterChosen doAfterChosen;
  DialogChoosePlayers({Key key, @required this.doAfterChosen})
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

class DialogPlayerBody extends StatefulWidget {
  final DoAfterChosen doAfterChosen;
  const DialogPlayerBody({Key key,@required this.doAfterChosen})
      : super(key: key);
  @override
  _DialogPlayerBodyState createState() => _DialogPlayerBodyState();
}

class _DialogPlayerBodyState extends State<DialogPlayerBody> {
  List<Player> players;
  String errorMessage;
  @override
  void initState() {
    super.initState();
    players = [];
  }

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: StreamBuilder<List<Player>>(
        stream: MyDatabase.db.watchAllPlayers,
        builder: (BuildContext context, AsyncSnapshot<List<Player>> snapshot) {
          List<Player> playerDb = [];
          if (!snapshot.hasError && snapshot.hasData) {
            playerDb = snapshot.data;
          }
          return Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ChoosePlayerFormField(
                              playerDb,
                              onSaved: (newValue) {
                                setState(() {
                                  if (players.contains(newValue)) {
                                    errorMessage =
                                        "Tous les noms doivent être différents";
                                    return;
                                  }
                                  if (newValue == null ||
                                      newValue.pseudo.isEmpty) {
                                    errorMessage = 'Veuillez entrer un nom';
                                    return;
                                  }
                                  errorMessage = null;
                                  players.add(newValue);
                                });
                              },
                              initialValue: Player(id: null, pseudo: ""),
                              validator: (value) {
                                var nbPlayers = players.length;
                                if (!NbPlayers.values
                                    .map((e) => getNumber(e))
                                    .contains(nbPlayers)) {
                                  return "Une partie avec $nbPlayers joueur${nbPlayers != 1 ? "s" : ""} n'existe pas";
                                }
                                return null;
                              },
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
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        elevation: 20,
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        padding: EdgeInsets.zero,
                                        label: Text(players[index].pseudo),
                                        backgroundColor: Colors.pink,
                                        deleteIcon: Icon(Icons.delete),
                                        deleteButtonTooltipMessage: "Supprimer",
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
                                errorMessage,
                                style: TextStyle(color: Colors.red),
                              )
                          ]),
                    ),
                  ),
                  RaisedButton(
                      color: Colors.amber,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          Navigator.of(context).pop();
                          widget.doAfterChosen(players);
                        }
                      },
                      child: Text("OK"))
                ]),
          );
        },
      ),
    );
  }
}
