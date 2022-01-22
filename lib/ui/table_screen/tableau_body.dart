import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/entry_screen/add_modify.dart';

class TableauBody extends ConsumerWidget {
  final List<PlayerBean> players;

  const TableauBody({Key? key, required this.players}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    textAlign: TextAlign.center,
                  ))),
        ),
      ),
      Container(
        constraints: const BoxConstraints.expand(height: 4),
        color: Colors.pink,
      ),
      StreamBuilder(
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
                  if (kDebugMode) {
                    print(players[index]);
                  }
                  final sum = sums[players[index].name]!;
                  return Expanded(
                    child: Text(
                      sum.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: sum < 0 ? Colors.red : Colors.green),
                    ),
                  );
                }),
              ),
            );
          }),
      Container(
        constraints: const BoxConstraints.expand(height: 4),
        color: Colors.pink,
      ),
      StreamBuilder<List<InfoEntryPlayerBean>>(
        stream: ref.watch(entriesProvider.select((value) => value.infoEntries)),
        builder: (BuildContext context,
            AsyncSnapshot<List<InfoEntryPlayerBean>> snapshot) {
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
          final entries = snapshot.data;
          if (entries == null || entries.isEmpty) {
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
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, double> calculateGain =
                      calculateGains(entries[index], players.toList());
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
                            backgroundColor: Colors.amber,
                            icon: Icons.edit,
                            foregroundColor: Colors.white,
                            onPressed: (context) async {
                              final modified = await Navigator.of(context)
                                  .pushNamed(AddModifyEntry.routeName,
                                      arguments: AddModifyArguments(
                                          players: players
                                              .map((e) => e.toDb)
                                              .toList(),
                                          infoEntry: entries[index]));
                              if (modified != null) {
                                ref
                                    .read(entriesProvider)
                                    .inModifyEntry
                                    .add(modified as InfoEntryPlayerBean);
                              }
                            },
                          ),
                        ]),
                    endActionPane: ActionPane(
                      extentRatio: 0.3,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          foregroundColor: Colors.white,
                          onPressed: (context) {
                            ref
                                .read(entriesProvider)
                                .inDeleteEntry
                                .add(entries[index]);

                            // key.currentState.dismiss(); // todo see
                          },
                        ),
                      ],
                    ),
                    child: Container(
                      color: index.isOdd ? Colors.grey : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(gains.length, (index) {
                            if (kDebugMode) {
                              print("Gain[$index] = ${gains[index]}");
                            }
                            return Expanded(
                              child: Text(
                                gains[index].toStringAsFixed(1),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: gains[index] >= 0
                                        ? Colors.grey[850]
                                        : Colors.red[900]),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    ]);
  }
}
