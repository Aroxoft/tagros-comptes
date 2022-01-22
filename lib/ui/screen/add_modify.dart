import 'package:another_flushbar/flushbar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/ui/widget/boxed.dart';
import 'package:tagros_comptes/ui/widget/selectable_tag.dart';
import 'package:tagros_comptes/util/half_decimal_input_formatter.dart';

class AddModifyEntry extends HookConsumerWidget {
  static String routeName = "/addModify";

  const AddModifyEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = useState(<PlayerBean>[]);
    final add = useState(false);
    final entry = useState(InfoEntryBean(points: 0, nbBouts: 0));
    final playerAttack = useState(PlayerBean.fromDb(
        (ModalRoute.of(context)!.settings.arguments! as AddModifyArguments)
            .players
            .last));
    final withPlayers = useState<List<PlayerBean?>?>(null);
    final args = useMemoized(() =>
        ModalRoute.of(context)!.settings.arguments! as AddModifyArguments);
    // final infoEntry = useState(InfoEntryPlayerBean(
    //     player: PlayerBean.fromDb(
    //         (ModalRoute.of(context)!.settings.arguments as AddModifyArguments)
    //             .players
    //             .last),
    //     infoEntry: InfoEntryBean(points: 0, nbBouts: 0)));
    useEffect(() {
      final playersValue = args.players.reversed
          .map((e) => PlayerBean.fromDb(e))
          .whereNotNull()
          .toList();
      players.value = playersValue;
      InfoEntryPlayerBean? info = args.infoEntry;
      if (kDebugMode) {
        print(
            "So we ${info == null ? "add" : "modify"} an entry, we have the players: $players");
      }
      add.value = false;
      if (info == null) {
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
      }
      playerAttack.value = info.player;
      entry.value = info.infoEntry;
      withPlayers.value = info.withPlayers;
    }, [0]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            S.of(context).addModifyAppBarTitle(add.value ? 'add' : 'modify')),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () {
            if (_validate(
                length: players.value.length,
                withPlayers: withPlayers.value,
                attack: playerAttack.value)) {
              Navigator.of(context).pop(InfoEntryPlayerBean(
                  player: playerAttack.value,
                  infoEntry: entry.value,
                  withPlayers: withPlayers.value));
            } else {
              Flushbar(
                title: S.of(context).addModifyMissingTitle,
                message: S.of(context).addModifyMissingMessage,
                duration: const Duration(seconds: 3),
              ).show(context);
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
                          Expanded(flex: 2, child: Text(S.of(context).preneur)),
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 35,
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: players.value.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
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
                                child: Text(S.of(context).addModifyFirstPartner(
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
                              child: Text(S.of(context).addModifySecondPartner),
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
                                  entry.value = entry.value.copyWith(prise: p);
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
                          Text(S.of(context).addModifyFor),
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
                              inputFormatters: [HalfDecimalInputFormatter()],
                              initialValue: entry.value.points.toString(),
                              onChanged: (String value) {
                                final points = value.isEmpty
                                    ? 0
                                    : double.tryParse(value) ?? 0;
                                entry.value = entry.value
                                    .copyWith(points: (points * 2).round() / 2);
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.lightGreen,
                                        width: 2,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(5),
                                    gapPadding: 1),
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                          ),
                          Text(S.of(context).points),
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
                          Text(S
                              .of(context)
                              .addModifyOudler(entry.value.nbBouts))
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
                                entry.value = entry.value.copyWith(poignees: p);
                              }
                            }),
                        Text(S.of(context).addModifyPoignee),
                        if (entry.value.poignees.isNotEmpty)
                          Flexible(
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
                                      entry.value =
                                          entry.value.copyWith(petitsAuBout: p);
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

class AddModifyArguments {
  InfoEntryPlayerBean? infoEntry;
  List<Player> players;

  AddModifyArguments({required this.infoEntry, required this.players});
}

enum Tagros { tagros, tarot }
