import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/clean_players_view_model.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';

class CleanPlayersScreen extends ConsumerWidget {
  const CleanPlayersScreen({super.key});

  static const routeName = '/cleanup';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slidableColor = ref.watch(themeColorProvider.select((value) => value
        .maybeWhen(
          data: (data) => data,
          orElse: () => ThemeColor.defaultTheme(),
        )
        .accentColor));
    return BackgroundGradient(
      child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).cleanupUnusedPlayersTitle),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(S.of(context).deleteAllDialogTitle),
                          content: Text(S.of(context).deleteAllDialogContent),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(S.of(context).actionCancel)),
                            TextButton(
                                onPressed: () {
                                  // delete
                                  ref
                                      .read(cleanPlayerProvider.notifier)
                                      .deleteAllUnused();
                                  Navigator.of(context).pop();
                                },
                                child: Text(S.of(context).actionDelete))
                          ],
                        );
                      },
                    );
                  },
                  tooltip: S.of(context).actionDeleteAllUnused,
                  icon: const Icon(Icons.delete_forever))
            ],
          ),
          body: StreamBuilder<List<Player>>(
            stream: ref.watch(cleanPlayerProvider),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    S.of(context).errorUnusedPlayers(snapshot.error.toString()),
                  ),
                );
              }
              final players = snapshot.data;
              if (players == null || players.isEmpty) {
                return Center(child: Text(S.of(context).playersUnusedEmpty));
              }
              return AnimatedList(
                initialItemCount: players.length,
                itemBuilder: (context, index, animation) {
                  final player = players[index];
                  return PlayerItem(
                      player: player,
                      animation: animation,
                      index: index,
                      slidableColor: slidableColor);
                },
              );
            },
          )),
    );
  }
}

/// widget to show a player in the list
class PlayerItem extends ConsumerWidget {
  const PlayerItem({
    super.key,
    required this.player,
    required this.animation,
    required this.index,
    required this.slidableColor,
  });

  final Animation<double> animation;
  final int index;
  final Color slidableColor;
  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: Key(player.id.toString()),
      endActionPane:
          ActionPane(extentRatio: 0.3, motion: const DrawerMotion(), children: [
        SlidableAction(
          icon: Icons.delete,
          backgroundColor: slidableColor,
          foregroundColor:
              slidableColor.isLight ? Colors.black87 : Colors.white70,
          onPressed: (context) {
            AnimatedList.of(context).removeItem(
                index,
                (context, animation) => ColoredBox(
                      color: Theme.of(context).colorScheme.error,
                      child: PlayerItem(
                        player: player,
                        animation: animation,
                        index: index,
                        slidableColor: slidableColor,
                      ),
                    ),
                duration: const Duration(milliseconds: 500));
            final provider = ref.read(cleanPlayerProvider.notifier);
            Future.delayed(const Duration(milliseconds: 500), () {
              provider.deletePlayer(idPlayer: player.id);
            });
          },
        )
      ]),
      child: SlideTransition(
        position: animation.drive(
          Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ),
        ),
        child: ColoredBox(
          color: index.isOdd ? Colors.black12 : Colors.white10,
          child: ListTile(
            title: Text(player.pseudo),
            leading: Text(player.id.toString()),
          ),
        ),
      ),
    );
  }
}
