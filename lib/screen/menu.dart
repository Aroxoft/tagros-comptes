import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/model/nb_players.dart';
import 'package:tagros_comptes/types/functions.dart';
import 'package:tagros_comptes/widget/dialog_players.dart';

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
  void initState() {
    super.initState();
    players = [];
  }

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
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return DialogChoosePlayers(doAfterChosen: doAfter);
        });
  }
}
