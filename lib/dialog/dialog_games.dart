import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game_with_players.dart';

class DialogChooseGame extends StatelessWidget {
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
                        (index) => ListTile(
                          title: Text("${games[index].players.length} joueurs"),
                          subtitle: Text(
                              "${games[index].game.date?.toIso8601String()}"),
                          onTap: () =>
                              navigateToTableau(context, game: games[index]),
                        ),
                      )),
                ),
              );
            }),
      ),
    );
  }
}
