import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/domain/calculus.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/presentation/tableau_view_model.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';

class TableauBody extends ConsumerWidget {
  final List<PlayerBean> players;

  const TableauBody({super.key, required this.players});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeColorProvider).maybeWhen(
        data: (data) => data, orElse: () => ThemeColor.defaultTheme());
    final TableauViewModel tableauVM = ref.watch(tableauViewModelProvider);
    final adCalculator = ref.watch(adsCalculatorProvider);
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
        child: StreamBuilder<Map<String, double>>(
            stream: tableauVM.sums,
            builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
              if (snapshot.hasError) {
                return Expanded(
                  child: SingleChildScrollView(
                      child: Text(
                          "Error: ${snapshot.error}\n${snapshot.stackTrace}")),
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
      StreamBuilder<List<InfoEntryPlayerBean>>(
        stream: tableauVM.entries,
        builder: (BuildContext context,
            AsyncSnapshot<List<InfoEntryPlayerBean>> snapshot) {
          if (snapshot.hasError) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ERROR: ${snapshot.error}\n${snapshot.stackTrace}"),
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
          final size = adCalculator.getFullListSize(itemsSize: entries.length);
          return Expanded(
            child: ListView.builder(
                itemCount: size,
                itemBuilder: (BuildContext context, int i) {
                  if (adCalculator.isAd(index: i, fullSize: size)) {
                    return _AdRow(ref: ref, index: i);
                  }
                  final index =
                      adCalculator.getItemIndex(position: i, fullSize: size);
                  if (index == null) {
                    return const SizedBox();
                  }
                  final Map<String, double> calculateGain =
                      calculateGains(entries[index], players.toList());
                  final gains =
                      transformGainsToList(calculateGain, players.toList());
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
                              final modified =
                                  await tableauVM.navigateToAddModify(context,
                                      infoEntry: entries[index]);
                              if (modified != null) {
                                tableauVM.modifyEntry(modified);
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
                            tableauVM.deleteEntry(entries[index].infoEntry.id!);
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
                }),
          );
        },
      ),
    ]);
  }
}

class _AdRow extends StatelessWidget {
  const _AdRow({
    required this.ref,
    required this.index,
  });

  final WidgetRef ref;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ref.watch(nativeAdProvider(index)).when(
          data: (ad) => SizedBox(height: 50, child: AdWidget(ad: ad)),
          error: (error, stack) => const SizedBox(),
          loading: () => const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
  }
}
