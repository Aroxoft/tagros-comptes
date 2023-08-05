import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/presentation/component/background_gradient.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';
import 'package:tagros_comptes/tagros/presentation/game_view_model.dart';
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
    final players = useState(<PlayerBean>[]);
    final add = useState(false);
    final entry = useState(InfoEntryBean(points: 0, nbBouts: 0));
    final playersArg = ref.watch(currentGameProvider).value?.players;
    final ValueNotifier<PlayerBean?> playerAttack = useState(
        playersArg != null ? PlayerBean.fromDb(playersArg.last) : null);
    final withPlayers = useState<List<PlayerBean?>?>(null);
    final textPointsController = useTextEditingController(text: "0");
    useEffect(() {
      if (playersArg == null) return null;
      final playersValue = playersArg.reversed
          .map((e) => PlayerBean.fromDb(e))
          .whereNotNull()
          .toList();
      players.value = playersValue;
      InfoEntryPlayerBean? info;
      if (roundId == null) {
        add.value = true;
        final pLength = playersValue.length;
        info = InfoEntryPlayerBean(
            player: playersValue[0],
            infoEntry: InfoEntryBean(points: 0, nbBouts: 0));
        if (pLength == 5) {
          info = info.copyWith(withPlayers: [playersValue[0]]);
        } else if (pLength > 5) {
          info = info.copyWith(withPlayers: [playersValue[0], playersValue[0]]);
        }
      } else {
        ref.read(gamesDaoProvider).fetchEntry(roundId!).then((info) {
          playerAttack.value = info.player;
          entry.value = info.infoEntry;
          withPlayers.value = info.withPlayers;
          textPointsController.text = info.infoEntry.points.toStringAsFixed(1);
        });
      }
      if (kDebugMode) {
        print(
            "So we ${roundId == null ? "add" : "modify"} an entry, we have the players: $players");
      }
      return null;
    }, [playersArg]);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              S.of(context).addModifyAppBarTitle(add.value ? 'add' : 'modify')),
        ),
        floatingActionButton: FloatingActionButton(
            heroTag: UniqueKey(),
            child: const Icon(Icons.check),
            onPressed: () {
              if (_validate(
                  length: players.value.length,
                  withPlayers: withPlayers.value,
                  attack: playerAttack.value)) {
                final infoEntry = InfoEntryPlayerBean(
                  player: playerAttack.value!,
                  infoEntry: entry.value,
                  withPlayers: withPlayers.value,
                );
                context.pop();
                SchedulerBinding.instance
                    .addPostFrameCallback((timeStamp) async {
                  if (add.value) {
                    ref.read(tableauViewModelProvider)?.addEntry(infoEntry);
                  } else {
                    ref.read(tableauViewModelProvider)?.modifyEntry(infoEntry);
                  }
                  ref.read(messageObserverProvider.notifier).state =
                      Tuple2(add.value, infoEntry);
                });
              } else {
                displayFlushbar(context, ref,
                    title: S.of(context).addModifyMissingTitle,
                    message: S.of(context).addModifyMissingMessage);
              }
            }),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                flex: 2, child: Text(S.of(context).preneur)),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 35,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: ListView.builder(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: players.value.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      SelectableTag(
                                          selected: playerAttack.value?.id ==
                                              players.value[index].id,
                                          text: players.value[index].name,
                                          onPressed: () {
                                            if (playerAttack.value?.id ==
                                                players.value[index].id) {
                                              playerAttack.value = null;
                                            } else {
                                              playerAttack.value =
                                                  players.value[index];
                                            }
                                          }),
                                ),
                              ),
                            ),
                          ]),
                      if (players.value.length >= 5)
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: Text(S
                                      .of(context)
                                      .addModifyFirstPartner(
                                          players.value.length > 5
                                              ? Tagros.tagros
                                              : Tagros.tarot))),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 35,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: ListView.builder(
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: players.value.length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          SelectableTag(
                                              selected: withPlayers.value?[0] ==
                                                  players.value[index],
                                              text: players.value[index].name,
                                              onPressed: () {
                                                final wPlayers =
                                                    withPlayers.value!.toList();
                                                if (withPlayers.value?[0] ==
                                                    players.value[index]) {
                                                  wPlayers[0] = null;
                                                } else {
                                                  wPlayers[0] =
                                                      players.value[index];
                                                }
                                                withPlayers.value = wPlayers;
                                              })),
                                ),
                              ),
                            ]),
                      if (players.value.length > 5)
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child:
                                    Text(S.of(context).addModifySecondPartner),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 35,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: ListView.builder(
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: players.value.length,
                                      itemBuilder: (BuildContext context,
                                              int index) =>
                                          SelectableTag(
                                              selected: withPlayers.value?[1] ==
                                                  players.value[index],
                                              text: players.value[index].name,
                                              onPressed: () {
                                                final wPlayers =
                                                    withPlayers.value!.toList();
                                                if (withPlayers.value?[1] ==
                                                    players.value[index]) {
                                                  wPlayers[1] = null;
                                                } else {
                                                  wPlayers[1] =
                                                      players.value[index];
                                                }
                                                withPlayers.value = wPlayers;
                                              })),
                                ),
                              ),
                            ]),
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(S.of(context).addModifyContractType),
                            DropdownButton(
                                value: entry.value.prise,
                                items: Prise.values
                                    .map((e) => DropdownMenuItem<Prise>(
                                        value: e, child: Text(e.displayName)))
                                    .toList(),
                                onChanged: (Prise? p) {
                                  if (p != null) {
                                    entry.value =
                                        entry.value.copyWith(prise: p);
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text(S.of(context).addModifyFor),
                            ),
                            DropdownButton<bool>(
                                value: entry.value.pointsForAttack,
                                items: [
                                  S.of(context).theAttack,
                                  S.of(context).theDefense
                                ]
                                    .map((e) => DropdownMenuItem<bool>(
                                        key: UniqueKey(),
                                        value: e == S.of(context).theAttack,
                                        child: Text(e)))
                                    .toList(),
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    entry.value = entry.value
                                        .copyWith(pointsForAttack: value);
                                  }
                                })
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              constraints:
                                  BoxConstraints.loose(const Size(60, 35)),
                              child: TextFormField(
                                controller: textPointsController,
                                onTap: () => textPointsController.selection =
                                    TextSelection(
                                        baseOffset: 0,
                                        extentOffset:
                                            textPointsController.text.length),
                                inputFormatters: [HalfDecimalInputFormatter()],
                                onChanged: (String value) {
                                  final points = value.isEmpty
                                      ? 0
                                      : double.tryParse(value) ?? 0;
                                  entry.value = entry.value.copyWith(
                                      points: (points * 2).round() / 2);
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            DropdownButton(
                                value: entry.value.nbBouts,
                                items: List.generate(
                                        players.value.length > 5 ? 7 : 4,
                                        (index) => index)
                                    .map((e) => DropdownMenuItem<int>(
                                        key: UniqueKey(),
                                        value: e,
                                        child: Text(e.toString())))
                                    .toList(),
                                onChanged: (int? value) {
                                  if (value != null) {
                                    entry.value =
                                        entry.value.copyWith(nbBouts: value);
                                    if (kDebugMode) {
                                      print(entry.value);
                                    }
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(S
                                  .of(context)
                                  .addModifyOudler(entry.value.nbBouts)),
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
                              value: entry.value.poignees.isNotEmpty &&
                                  entry.value.poignees[0] != PoigneeType.none,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  var p = entry.value.poignees.toList();
                                  if (p.isEmpty) {
                                    p = [PoigneeType.simple];
                                  }
                                  p[0] = value
                                      ? PoigneeType.simple
                                      : PoigneeType.none;
                                  entry.value =
                                      entry.value.copyWith(poignees: p);
                                }
                              }),
                          Expanded(
                              flex: 1,
                              child: Text(S.of(context).addModifyPoignee)),
                          if (entry.value.poignees.isNotEmpty)
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: DropdownButton<PoigneeType>(
                                    value: entry.value.poignees[0],
                                    isExpanded: true,
                                    items: PoigneeType.values
                                        .map(
                                          (e) => DropdownMenuItem<PoigneeType>(
                                              key: UniqueKey(),
                                              value: e,
                                              child: Text(S
                                                  .of(context)
                                                  .addModifyPoigneeNbTrumps(
                                                      getNbAtouts(e,
                                                          players.value.length),
                                                      e.displayName))),
                                        )
                                        .toList(),
                                    onChanged: (PoigneeType? poignee) {
                                      if (poignee != null) {
                                        final p = entry.value.poignees.toList();
                                        p[0] = poignee;
                                        entry.value =
                                            entry.value.copyWith(poignees: p);
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
                              value: entry.value.petitsAuBout.isNotEmpty &&
                                  entry.value.petitsAuBout[0] != Camp.none,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  var p = entry.value.petitsAuBout.toList();
                                  if (p.isEmpty) {
                                    p = [Camp.attack];
                                  }
                                  p[0] = value ? Camp.attack : Camp.none;
                                  entry.value =
                                      entry.value.copyWith(petitsAuBout: p);
                                }
                              }),
                          Text(S.of(context).addModifyPetitAuBout),
                          if (entry.value.petitsAuBout.isNotEmpty)
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: DropdownButton<Camp>(
                                    value: entry.value.petitsAuBout[0],
                                    items: Camp.values
                                        .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e.displayName),
                                            ))
                                        .toList(),
                                    onChanged: (Camp? petit) {
                                      if (petit != null) {
                                        final p =
                                            entry.value.petitsAuBout.toList();
                                        p[0] = petit;
                                        entry.value = entry.value
                                            .copyWith(petitsAuBout: p);
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
        ),
      ),
    );
  }

  bool _validate(
      {required int length,
      required PlayerBean? attack,
      required List<PlayerBean?>? withPlayers}) {
    if (attack == null) return false;
    if (length < 5) return true;
    if (withPlayers == null || withPlayers.isEmpty) return false;
    if (length == 5) return true;
    if (withPlayers.length != 2) return false;
    return true;
  }
}

enum Tagros { tagros, tarot }
