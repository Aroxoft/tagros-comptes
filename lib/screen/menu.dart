import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game.dart';
import 'package:tagros_comptes/model/nb_players.dart';
import 'package:tagros_comptes/model/player.dart';
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
        body: MenuBody()
    );
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
                              game: Game(nbPlayers: getNumber(NbPlayers
                                  .values[index]),
                                  dateTime: DateTime.now(), players: players));
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
    players = List.generate(nbPlayers, (index) => Player(name: ""));
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

              child: FutureBuilder<List<Player>>(
                future: DBProvider.db.getPlayers(),
                builder: (BuildContext context, AsyncSnapshot<List<
                    Player>> snapshot) {
                  List<Player> playerDb = [];
                  if (!snapshot.hasError && snapshot.hasData) {
                    playerDb = snapshot.data;
                  }
                  print("in futureBuilder, players: $playerDb");
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    List.generate(nbPlayers, (int index) {
                      return ChoosePlayerFormField(
                        playerDb, validator: (value) {
                        if (value == null || value.name.isEmpty) {
                          return 'Veuillez entrer un nom';
                        }
                        if ((players.toList()
                          ..remove(value)).contains(value)) {
                          return 'Tous les noms doivent être différents';
                        }
                        return null;
                      },
                        onSaved: (newValue) => players[index] = newValue,
                        initialValue: players[index],
                      );
//                      if (index == nbPlayers * 3) {
//                        return Visibility(
//                            visible: hasEmpty(players) || hasDuplicate(players),
//                            child: Text(
//                                hasEmpty(players)
//                                    ? "Veuillez remplir tous les noms"
//                                    :
//                                hasDuplicate(players)
//                                    ? "Tous les noms doivent être différents"
//                                    : ""));
//                      } else if (index % 3 == 0) {
//                        return Text("Joueur ${(index / 3).floor() + 1}",
//                          style: TextStyle(fontSize: 16,),);
//                      } else if (index % 3 == 1) {
//                        var i = (index / 3).floor();
//                        return Visibility(
//                            visible: players[i].name != null &&
//                                players[i].name.isNotEmpty,
//                            child: SelectableTag(
//                                text: controllers[i].text,
//                                onPressed: () {})
//                        );
//                      } else {
//                        var i = (index / 3).floor();
//                        return Row(
//                          mainAxisSize: MainAxisSize.min,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: <Widget>[
//                            Expanded(
//                              child: AutoCompleteTextField<Player>(
//                                  style: TextStyle(fontSize: 16),
//                                  decoration: InputDecoration(
//                                      contentPadding: EdgeInsets.symmetric(
//                                          horizontal: 10, vertical: 20),
//                                      filled: true,
//                                      hintText: 'Nom du joueur',
//                                      hintStyle: TextStyle(
//                                          color: Colors.blueGrey)),
//                                  itemSubmitted: (p) {
//                                    controllers[i].text = p.name;
//                                    setState(() {
//                                      players[i] = p;
//                                    });
//                                  },
//                                  controller: controllers[i],
//                                  key: keys[i],
//                                  suggestions: playerDb,
//                                  itemBuilder: (BuildContext context,
//                                      Player item) =>
//                                      Padding(
//                                        padding: const EdgeInsets.all(8.0),
//                                        child: Text(item.name,
//                                            style: TextStyle(
//                                                fontSize: 16,
//                                                color: Colors.red)),
//                                      ),
//                                  itemSorter: (a, b) =>
//                                      a.name.compareTo(b.name),
//                                  itemFilter: (item, query) =>
//                                      item.name.toLowerCase().startsWith(query
//                                          .toLowerCase())
//                              ),
//                            ),
//                            IconButton(
//                                icon: Icon(Icons.add), onPressed: () async {
//                              var text = controllers[i].text;
//                              players[i].name = text;
//                              if (playerDb.any((element) =>
//                              element.name == text)) {
//                                // We have this player in db
//                                players[i].id = playerDb
//                                    .firstWhere((element) =>
//                                element.name == text)
//                                    .id;
//                              } else { // Create in DB
//                                await DBProvider.db.newPlayer(players[i]);
//                              }
//                              setState(() {});
//                              print("added! $players");
//                            }),
//                          ],
//                        );
////                      return ChoosePlayer();
//                      }
//
//
                    }),
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
