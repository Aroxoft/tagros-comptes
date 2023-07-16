import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/navigation.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/game_provider.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class DialogChooseGame extends ConsumerWidget {
  const DialogChooseGame({super.key});

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
            final theme = ref.watch(themeColorProvider).maybeWhen(
                data: (data) => data, orElse: () => ThemeColor.defaultTheme());
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
                            backgroundColor: theme.accentColor,
                            foregroundColor: theme.accentColor.isLight
                                ? Colors.black87
                                : Colors.white70,
                            icon: Icons.delete,
                            onPressed: (context) {
                              ref
                                  .read(gamesDaoProvider)
                                  .deleteGame(games[index]);
                            },
                          )
                        ],
                      ),
                      child: Consumer(
                        builder: (context, ref, child) => ListTile(
                          leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              child: Text(
                                  games[index].players.length.toString(),
                                  style: TextStyle(
                                      color: theme.averageBackgroundColor))),
                          title: Text(S
                              .of(context)
                              .nbPlayers(games[index].players.length)),
                          subtitle: child,
                          onTap: () {
                            Navigator.of(context).pop();
                            navigateToTableau(context);
                            ref.read(currentGameIdProvider.notifier).setGame(
                                CurrentGameConstructorExistingGame(
                                    games[index].game.id.value));
                          },
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  timeago.format(games[index].game.date.value)),
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
