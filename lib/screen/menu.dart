import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/model/nb_players.dart';
import 'package:tagros_comptes/types/functions.dart';
import 'package:tagros_comptes/widget/choose_player.dart';

class MenuScreen extends StatelessWidget {
  static const routeName = "/menu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Compteur Tagros"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  print("pressed settings");
                })
          ],
        ),
        body: MenuBody());
  }
}

class MenuBody extends StatefulWidget {
  @override
  _MenuBodyState createState() => _MenuBodyState();
}

class _MenuBodyState extends State<MenuBody> {
  List<Player> players;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: NbPlayers.values.length,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              child: RaisedButton(
                  elevation: 4,
                  color: Colors.amber,
                  onPressed: () {
                    showDialogPlayers(
                        context, getNumber(NbPlayers.values[index]),
                        doAfter: (List<Player> players) {
                      print("chose: $players");
                      navigateToTableau(context,
                          game: GameWithPlayers(
                              nbPlayers: getNumber(NbPlayers.values[index]),
                              dateTime: DateTime.now(),
                              players: players));
                    });
                  },
                  child: Text("${getNumber(NbPlayers.values[index])} players")),
            );
          }),
    );
  }

  showDialogPlayers(BuildContext context, int nbPlayers,
      {DoAfterChosen doAfter}) {
    final formKey = GlobalKey<FormState>();
    players = List.generate(nbPlayers, (index) => Player(pseudo: "", id: null));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
//          List<TextEditingController> controllers = List.generate(
//              nbPlayers, (index) => TextEditingController());
//          List<GlobalKey<AutoCompleteTextFieldState<Player>>> keys = List
//              .generate(nbPlayers, (index) => GlobalKey());
          return AlertDialog(
            content: Form(
              key: formKey,
              child: StreamBuilder<List<Player>>(
                stream: MyDatabase.db.watchAllPlayers,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Player>> snapshot) {
                  List<Player> playerDb = [];
                  if (!snapshot.hasError && snapshot.hasData) {
                    playerDb = snapshot.data;
                  }
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(nbPlayers, (int index) {
                          return ChoosePlayerFormField(
                            playerDb,
                            validator: (value) {
                              if (value == null || value.pseudo.isEmpty) {
                                return 'Veuillez entrer un nom';
                              }
                              if ((players.toList()..remove(value))
                                  .contains(value)) {
                                return 'Tous les noms doivent être différents';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              players[index] = newValue;
                            },
                            initialValue: players[index],
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      Navigator.of(context).pop();
                      doAfter(players);
                    }
                  },
                  child: Text("OK"))
            ],
          );
        });
  }
}
