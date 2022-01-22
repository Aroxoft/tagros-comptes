import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:timeago/timeago.dart' as timeago;

class DialogChooseGame extends ConsumerWidget {
  const DialogChooseGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      content: StreamBuilder<List<GameWithPlayers>>(
          stream: ref.watch(databaseProvider
              .select((value) => value.gamesDao.watchAllGamesDrift())),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return Text(S.of(context).dialogGamesNoData);
            }
            final games = snapshot.data;
            if (games == null || games.isEmpty) {
              return Text(S.of(context).dialogGamesNoGames);
            }
            return SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    games.length,
                    (index) => Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
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
                            child: Text(games[index].players.length.toString(),
                                style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(S
                              .of(context)
                              .nbPlayers(games[index].players.length)),
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
                              Text(timeago.format(games[index].game.date.value)),
                              Text(
                                games[index]
                                    .players
                                    .map((e) => e.pseudo)
                                    .join(", "),
                                overflow: TextOverflow.ellipsis,
                              )
                            ]),
                      ),
                    ),
                  )),
            );
          }),
    );
  }
}
