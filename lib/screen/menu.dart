import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/bloc/game_db_bloc.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/dialog/dialog_games.dart';
import 'package:tagros_comptes/dialog/dialog_players.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/screen/test_native.dart';
import 'package:tagros_comptes/types/functions.dart';

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
                  Navigator.of(context).pushNamed(TestNative.routeName);
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
  GameDbBloc _gameDbBloc;
  @override
  void initState() {
    super.initState();
    players = [];
    _gameDbBloc = BlocProvider.of<GameDbBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.amber,
          onPressed: () {
            showDialogPlayers(context,
                doAfter: (players) => navigateToTableau(context,
                    game: GameWithPlayers(
                        game: Game(
                            id: null,
                            nbPlayers: players.length,
                            date: DateTime.now()),
                        players: players)));
          },
          child: Text("Nouvelle partie"),
        ),
        RaisedButton(
            child: Text("Continuer"),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => DialogChooseGame(
                  gameDbBloc: _gameDbBloc,
                ),
              );
            })
      ],
    ));
  }

  showDialogPlayers(BuildContext context, {DoAfterChosen doAfter}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return DialogChoosePlayers(doAfterChosen: doAfter);
        });
  }
}
