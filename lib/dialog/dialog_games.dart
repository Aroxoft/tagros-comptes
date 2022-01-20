import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/state/providers.dart';

class DialogChooseGame extends ConsumerWidget {
  const DialogChooseGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: Container(
        child: StreamBuilder<List<GameWithPlayers>>(
            stream: ref.watch(databaseProvider).watchAllGames(),
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
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                foregroundColor: Colors.red,
                                icon: Icons.delete,
                                onPressed: (context) {
                                  ref
                                      .read(gameChangeProvider)
                                      .inDeleteGame
                                      .add(games[index]);
                                },
                              )
                            ],
                          ),
                          child: Consumer(
                            builder: (context, ref, child) => ListTile(
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
                              subtitle: child,
                              onTap: () {
                                Navigator.of(context).pop();
                                navigateToTableau(context,
                                    game: games[index],
                                    appDatabase: ref.read(databaseProvider));
                              },
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${games[index].game.date?.toIso8601String()}"),
                                  Text(
                                    "${games[index].players.map((e) => e.pseudo).join(", ")}",
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ]),
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
