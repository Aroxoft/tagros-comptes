import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';

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
                                ref.read(cleanPlayerProvider).deleteAllUnused();
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
            stream: ref.watch(
                cleanPlayerProvider.select((value) => value.unusedPlayers)),
            initialData: null,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(S
                      .of(context)
                      .errorUnusedPlayers(snapshot.error.toString())),
                );
              }
              final players = snapshot.data;
              if (players == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (players.isEmpty) {
                return Center(child: Text(S.of(context).playersUnusedEmpty));
              }
              return ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Slidable(
                    endActionPane: ActionPane(
                        extentRatio: 0.3,
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            icon: Icons.delete,
                            backgroundColor: slidableColor,
                            foregroundColor: slidableColor.isLight
                                ? Colors.black87
                                : Colors.white70,
                            onPressed: (context) {
                              ref
                                  .read(cleanPlayerProvider)
                                  .deletePlayer(idPlayer: player.id);
                            },
                          )
                        ]),
                    child: ListTile(
                      title: Text(player.pseudo),
                      leading: Text(player.id.toString()),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
