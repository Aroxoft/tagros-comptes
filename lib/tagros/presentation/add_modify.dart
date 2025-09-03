import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';
import 'package:tagros_comptes/tagros/presentation/entry_view_model.dart';
import 'package:tagros_comptes/tagros/presentation/widget/boxed.dart';
import 'package:tagros_comptes/tagros/presentation/widget/selectable_tag.dart';
import 'package:tagros_comptes/tagros/presentation/widget/snack_utils.dart';
import 'package:tagros_comptes/util/half_decimal_input_formatter.dart';
import 'package:tuple/tuple.dart';

class EntryScreen extends HookConsumerWidget {
  static String routeName = "/addModify";
  final int? roundId;

  const EntryScreen({super.key, required this.roundId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final add = ref.watch(entryViewModelProvider(roundId: roundId)
        .select((value) => value.value?.id == null));
    final textPointsController = useTextEditingController(text: "0");
    useEffect(() {
      textPointsController.text = ref.read(entryViewModelProvider(
              roundId: roundId)
          .select((value) => value.value?.points.toStringAsFixed(1) ?? "0"));
      return null;
    }, [
      ref.watch(entryViewModelProvider(roundId: roundId)
          .select((value) => value.value == null))
    ]);
    if (kDebugMode) {
      print("So we ${roundId == null ? "add" : "modify"} an entry");
    }
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(S.of(context).addModifyAppBarTitle(add ? 'add' : 'modify')),
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: UniqueKey(),
            child: const Icon(Icons.check),
            onPressed: () {
              final (saved, added) = ref
                  .read(entryViewModelProvider(roundId: roundId).notifier)
                  .saveEntry();
              if (saved != null) {
                context.pop();
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  ref.read(messageObserverProvider.notifier).state =
                      Tuple2(added, saved);
                });
              } else {
                displayFlushbar(context, ref,
                    title: S.of(context).addModifyMissingTitle,
                    message: S.of(context).addModifyMissingMessage);
              }
            }),
        body: ref.watch(entryViewModelProvider(roundId: roundId).select(
            (value) => value.when(
                data: (data) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Boxed(
                            title: S.of(context).addModifyTitleAttack,
                            child: Column(
                              children: <Widget>[
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Text(S.of(context).preneur)),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          height: 35,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: ListView.builder(
                                            key: const ValueKey('player1'),
                                            reverse: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: data.allPlayers.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final player =
                                                  data.allPlayers[index];
                                              return SelectableTag(
                                                  selected: data.taker?.id ==
                                                      player.id,
                                                  text: player.name,
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            entryViewModelProvider(
                                                                    roundId:
                                                                        roundId)
                                                                .notifier)
                                                        .setTaker(player);
                                                  });
                                            },
                                          ),
                                        ),
                                      ),
                                    ]),
                                if (data.showPartnerPage)
                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            flex: 2,
                                            child: Text(S
                                                .of(context)
                                                .addModifyFirstPartner(
                                                    data.allPlayers.length > 5
                                                        ? Tagros.tagros
                                                        : Tagros.tarot))),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            height: 35,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: ListView.builder(
                                                key: const ValueKey('player2'),
                                                reverse: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    data.allPlayers.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final player =
                                                      data.allPlayers[index];
                                                  return SelectableTag(
                                                      selected:
                                                          data.partner1?.id ==
                                                              player.id,
                                                      text: player.name,
                                                      onPressed: () {
                                                        ref
                                                            .read(entryViewModelProvider(
                                                                    roundId:
                                                                        roundId)
                                                                .notifier)
                                                            .setPartner1(
                                                                player);
                                                      });
                                                }),
                                          ),
                                        ),
                                      ]),
                                if (data.showPartner2Page)
                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Text(S
                                              .of(context)
                                              .addModifySecondPartner),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Container(
                                            height: 35,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2),
                                            child: ListView.builder(
                                                key: const ValueKey('player3'),
                                                reverse: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    data.allPlayers.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final player =
                                                      data.allPlayers[index];
                                                  return SelectableTag(
                                                      selected:
                                                          data.partner2?.id ==
                                                              player.id,
                                                      text: player.name,
                                                      onPressed: () {
                                                        ref
                                                            .read(entryViewModelProvider(
                                                                    roundId:
                                                                        roundId)
                                                                .notifier)
                                                            .setPartner2(
                                                                player);
                                                      });
                                                }),
                                          ),
                                        ),
                                      ]),
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(S.of(context).addModifyContractType),
                                      DropdownButton(
                                          key: const ValueKey(
                                              'dropdown-contract'),
                                          value: data.prise,
                                          items: Prise.values
                                              .map((e) =>
                                                  DropdownMenuItem<Prise>(
                                                      value: e,
                                                      child:
                                                          Text(e.displayName)))
                                              .toList(),
                                          onChanged: (Prise? p) {
                                            if (p != null) {
                                              ref
                                                  .read(entryViewModelProvider(
                                                          roundId: roundId)
                                                      .notifier)
                                                  .setPrise(p);
                                            }
                                          })
                                    ]),
                              ],
                            ),
                          ),
                          Boxed(
                              title: S.of(context).addModifyTitleContract,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Text(S.of(context).addModifyFor),
                                      ),
                                      DropdownButton<bool>(
                                          value: data.pointsForAttack,
                                          items: [
                                            S.of(context).theAttack,
                                            S.of(context).theDefense
                                          ]
                                              .map((e) =>
                                                  DropdownMenuItem<bool>(
                                                      key: UniqueKey(),
                                                      value: e ==
                                                          S
                                                              .of(context)
                                                              .theAttack,
                                                      child: Text(e)))
                                              .toList(),
                                          onChanged: (bool? value) {
                                            if (value != null) {
                                              ref
                                                  .read(entryViewModelProvider(
                                                          roundId: roundId)
                                                      .notifier)
                                                  .setPointsForAttack(value);
                                            }
                                          })
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        constraints: BoxConstraints.loose(
                                            const Size(60, 35)),
                                        child: TextFormField(
                                          controller: textPointsController,
                                          onTap: () =>
                                              textPointsController.selection =
                                                  TextSelection(
                                                      baseOffset: 0,
                                                      extentOffset:
                                                          textPointsController
                                                              .text.length),
                                          inputFormatters: [
                                            HalfDecimalInputFormatter()
                                          ],
                                          onChanged: (String value) => ref
                                              .read(entryViewModelProvider(
                                                      roundId: roundId)
                                                  .notifier)
                                              .setPoints(value),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Text(S.of(context).points),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      DropdownButton(
                                          key: const ValueKey(
                                              'dropdown-oudlers'),
                                          value: data.nbBouts,
                                          items: List.generate(
                                                  data.allPlayers.length > 5
                                                      ? 7
                                                      : 4,
                                                  (index) => index)
                                              .map((e) => DropdownMenuItem<int>(
                                                  key: UniqueKey(),
                                                  value: e,
                                                  child: Text(e.toString())))
                                              .toList(),
                                          onChanged: (int? value) {
                                            if (value != null) {
                                              ref
                                                  .read(entryViewModelProvider(
                                                          roundId: roundId)
                                                      .notifier)
                                                  .setNbBouts(value);
                                            }
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(S
                                            .of(context)
                                            .addModifyOudler(data.nbBouts)),
                                      )
                                    ],
                                  )
                                ],
                              )),
                          Boxed(
                              title: S.of(context).addModifyBonus,
                              child: Column(children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Checkbox(
                                        value: data.poignees.isNotEmpty &&
                                            data.poignees[0] !=
                                                PoigneeType.none,
                                        onChanged: (bool? value) {
                                          if (value != null) {
                                            ref
                                                .read(entryViewModelProvider(
                                                        roundId: roundId)
                                                    .notifier)
                                                .switchPoignee(value);
                                          }
                                        }),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            S.of(context).addModifyPoignee)),
                                    if (data.poignees.isNotEmpty)
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: DropdownButton<PoigneeType>(
                                              key: const ValueKey(
                                                  'dropdown-handful'),
                                              value: data.poignees[0],
                                              isExpanded: true,
                                              items: PoigneeType.values
                                                  .map(
                                                    (e) => DropdownMenuItem<
                                                            PoigneeType>(
                                                        key: UniqueKey(),
                                                        value: e,
                                                        child: Text(S
                                                            .of(context)
                                                            .addModifyPoigneeNbTrumps(
                                                                getNbAtouts(
                                                                    e,
                                                                    data.allPlayers
                                                                        .length),
                                                                e.displayName))),
                                                  )
                                                  .toList(),
                                              onChanged:
                                                  (PoigneeType? poignee) {
                                                if (poignee != null) {
                                                  ref
                                                      .read(
                                                          entryViewModelProvider(
                                                                  roundId:
                                                                      roundId)
                                                              .notifier)
                                                      .setPoignee(poignee);
                                                }
                                              }),
                                        ),
                                      ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Checkbox(
                                        value: data.petitsAuBout.isNotEmpty &&
                                            data.petitsAuBout[0] != Camp.none,
                                        onChanged: (bool? value) {
                                          if (value != null) {
                                            ref
                                                .read(entryViewModelProvider(
                                                        roundId: roundId)
                                                    .notifier)
                                                .switchPetitAuBout(value);
                                          }
                                        }),
                                    Text(S.of(context).addModifyPetitAuBout),
                                    if (data.petitsAuBout.isNotEmpty)
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: DropdownButton<Camp>(
                                              key: const ValueKey(
                                                  'dropdown-petit'),
                                              value: data.petitsAuBout[0],
                                              items: Camp.values
                                                  .map((e) => DropdownMenuItem(
                                                        value: e,
                                                        child:
                                                            Text(e.displayName),
                                                      ))
                                                  .toList(),
                                              onChanged: (Camp? petit) {
                                                if (petit != null) {
                                                  ref
                                                      .read(
                                                          entryViewModelProvider(
                                                                  roundId:
                                                                      roundId)
                                                              .notifier)
                                                      .setPetitAuBout(petit);
                                                }
                                              }),
                                        ),
                                      )
                                  ],
                                )
                              ])),
                        ],
                      ),
                    ),
                  );
                },
                error: (error, stack) => Center(child: Text(error.toString())),
                loading: () =>
                    const Center(child: CircularProgressIndicator())))),
      ),
    );
  }
}

enum Tagros { tagros, tarot }
