import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tagros_comptes/bloc/game_db_bloc.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game_with_players.dart';

class DialogChooseGame extends StatelessWidget {
  final GameDbBloc gameDbBloc;

  const DialogChooseGame({Key key, @required this.gameDbBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: StreamBuilder<List<GameWithPlayers>>(
            stream: MyDatabase.db.watchAllGames(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (!snapshot.hasData) {
                return Text("No data");
              }
              var games = snapshot.data;
              if (games == null || games.isEmpty) {
                return Text("Pas de parties enregistrées");
              }
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        games.length,
                        (index) => Slidable(
                          actionPane: SlidableStrechActionPane(),
                          actionExtentRatio: 0.33,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              color: Colors.red,
                              icon: Icons.delete,
                              foregroundColor: Colors.white,
                              onTap: () {
                                gameDbBloc.inDeleteGame.add(games[index]);
                              },
                            )
                          ],
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Colors.indigo[Random().nextInt(10) * 100],
                              child: Text(
                                  "${games[index].players.length.toString()}",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            title: Text(
                              "${games[index].players.length} joueurs",
                            ),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${games[index].game.date?.toIso8601String()}"),
                                  Text(
                                    "${games[index].players.map((e) => e.pseudo).join(", ")}",
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ]),
                            onTap: () {
                              Navigator.of(context).pop();
                              return navigateToTableau(context,
                                  game: games[index]);
                            },
                          ),
                        ),
                      )),
                ),
              );
            }),
      ),
    );
  }
}
