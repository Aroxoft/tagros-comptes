import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/main.dart';
import 'package:tagros_comptes/model/game/player.dart';
import 'package:tagros_comptes/model/monetization/ad_or_info.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:tagros_comptes/services/calculous/calculus.dart';
import 'package:tagros_comptes/state/providers.dart';

class TableauBody extends ConsumerWidget {
  final List<PlayerBean> players;

  const TableauBody({super.key, required this.players});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeColorProvider).maybeWhen(
        data: (data) => data, orElse: () => ThemeColor.defaultTheme());
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
              players.length,
              (index) => Expanded(
                      child: Text(
                    players[index].name.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: theme.playerNameColor),
                    textAlign: TextAlign.center,
                  ))),
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: theme.horizontalColor, width: 4),
              bottom: BorderSide(color: theme.horizontalColor, width: 4)),
        ),
        child: StreamBuilder(
            stream: ref.watch(entriesProvider.select((value) => value.sum)),
            builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
              final sums = snapshot.data;
              if (sums == null) {
                return Center(
                  child: Text(S.of(context).tableNoData),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(sums.length, (index) {
                    final sum = sums[players[index].name]!;
                    return Expanded(
                      child: Text(
                        sum.toStringAsFixed(1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: sum < 0
                                ? theme.negativeSumColor
                                : theme.positiveSumColor),
                      ),
                    );
                  }),
                ),
              );
            }),
      ),
      StreamBuilder<List<AdOrInfo>>(
        stream: ref.watch(entriesProvider.select((value) => value.rows)),
        builder:
            (BuildContext context, AsyncSnapshot<List<AdOrInfo>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ERROR: ${snapshot.error}"),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(S.of(context).tableNoData),
              ),
            );
          }
          final rows = snapshot.data;
          if (rows == null || rows.isEmpty) {
            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).tableNoEntry),
                ),
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
                itemCount: rows.length,
                itemBuilder: (BuildContext context, int index) {
                  final row = rows[index];
                  return row.when(
                    ad: (ad) => FutureBuilder<AdWithView>(
                        future: ad,
                        builder: (context, snapshot) {
                          return AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            child: SizedBox(
                              height: snapshot.hasError
                                  ? 50
                                  : snapshot.data == null
                                      ? 0
                                      : 200,
                              child: snapshot.hasError
                                  ? Text(
                                      "Here my ad should have been ${snapshot.error}")
                                  : snapshot.hasData
                                      ? AdWidget(ad: snapshot.data!)
                                      : const SizedBox(),
                            ),
                          );
                        }),
                    info: (infoEntryPlayerBean) {
                      final Map<String, double> calculateGain =
                          calculateGains(infoEntryPlayerBean, players.toList());
                      final gains =
                          transformGainsToList(calculateGain, players.toList());
                      // var key = GlobalKey<SlidableState>();
                      return Slidable(
                        key: ValueKey(index),
                        startActionPane: ActionPane(
                            extentRatio: 0.3,
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: theme.accentColor,
                                icon: Icons.edit,
                                foregroundColor: theme.accentColor.isLight
                                    ? Colors.black87
                                    : Colors.white70,
                                onPressed: (context) async {
                                  final modified = await navigateToAddModify(
                                      context,
                                      game: ref.read(gameProvider),
                                      infoEntry: infoEntryPlayerBean);
                                  if (modified != null) {
                                    ref
                                        .read(entriesProvider)
                                        .inModifyEntry
                                        .add(modified);
                                  }
                                },
                              ),
                            ]),
                        endActionPane: ActionPane(
                          extentRatio: 0.3,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              backgroundColor: theme.accentColor,
                              icon: Icons.delete,
                              foregroundColor: theme.accentColor.isLight
                                  ? Colors.black87
                                  : Colors.white70,
                              onPressed: (context) {
                                ref
                                    .read(entriesProvider)
                                    .inDeleteEntry
                                    .add(infoEntryPlayerBean);

                                // key.currentState.dismiss(); // todo see
                              },
                            ),
                          ],
                        ),
                        child: ColoredBox(
                          color: index.isOdd ? Colors.black12 : Colors.white10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(gains.length, (index) {
                                return Expanded(
                                  child: Text(
                                    gains[index].toStringAsFixed(1),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: gains[index] >= 0
                                            ? theme.positiveEntryColor
                                            : theme.negativeEntryColor),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          );
        },
      ),
    ]);
  }
}
