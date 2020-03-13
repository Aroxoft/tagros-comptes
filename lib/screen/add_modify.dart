import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';
import 'package:tagros_comptes/util/half_decimal_input_formatter.dart';
import 'package:tagros_comptes/widget/boxed.dart';
import 'package:tagros_comptes/widget/selectable_tag.dart';

class AddModifyEntry extends StatefulWidget {
  static String routeName = "/addModify";

  @override
  _AddModifyEntryState createState() => _AddModifyEntryState();
}

class _AddModifyEntryState extends State<AddModifyEntry> {
  InfoEntryPlayerBean infoEntry;
  bool add;
  List<PlayerBean> players;

  @override
  void initState() {
    infoEntry = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (infoEntry == null) {
      final AddModifyArguments args = ModalRoute.of(context).settings.arguments;
      infoEntry = args.infoEntry;
      players = args.players.reversed.map((e) => PlayerBean.fromDb(e)).toList();
      print(
          "So we ${infoEntry == null ? "add" : "modify"} an entry, we have the players: $players");
      add = false;
      if (infoEntry == null) {
        add = true;
        var pLength = players.length;
        infoEntry = InfoEntryPlayerBean(
            player: players[0],
            withPlayers: null,
            infoEntry: InfoEntryBean(points: 0, nbBouts: 0));
        if (pLength == 5) {
          infoEntry.withPlayers = [players[0]];
        } else if (pLength > 5) {
          infoEntry.withPlayers = [players[0], players[0]];
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${(add ? "Ajout" : "Modification")} d'une partie"),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            if (_validate(infoEntry)) {
              Navigator.of(context).pop(infoEntry);
            } else {
              Flushbar(
                title: "Il manque des informations",
                message:
                    "Pour pouvoir valider, veuillez ajouter les informations manquantes",
                duration: Duration(seconds: 3),
              )..show(context);
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
                child: Column(
                  children: <Widget>[
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(flex: 2, child: Text("Preneur")),
                          Expanded(
                            flex: 5,
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: ListView.builder(
                                reverse: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: players.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    SelectableTag(
                                        selected: infoEntry.player.id ==
                                            players[index].id,
                                        text: players[index].name,
                                        onPressed: () {
                                          setState(() {
                                            if (infoEntry.player.id ==
                                                players[index].id) {
                                              infoEntry.player = null;
                                            } else {
                                              infoEntry.player = players[index];
                                            }
                                          });
                                        }),
                              ),
                            ),
                          ),
                        ]),
                    if (players.length >= 5)
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "Partenaire${players.length > 5 ? " numéro 1" : ""}"),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: ListView.builder(
                                    reverse: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: players.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        SelectableTag(
                                            selected:
                                                infoEntry.withPlayers[0] ==
                                                    players[index],
                                            text: players[index].name,
                                            onPressed: () {
                                              setState(() {
                                                if (infoEntry.withPlayers[0] ==
                                                    players[index]) {
                                                  infoEntry.withPlayers[0] =
                                                      null;
                                                } else {
                                                  infoEntry.withPlayers[0] =
                                                      players[index];
                                                }
                                              });
                                            })),
                              ),
                            ),
                          ]),
                    if (players.length > 5)
                      Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text("Partenaire numéro 2"),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: ListView.builder(
                                    reverse: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: players.length,
                                    itemBuilder: (BuildContext context,
                                            int index) =>
                                        SelectableTag(
                                            selected:
                                                infoEntry.withPlayers[1] ==
                                                    players[index],
                                            text: players[index].name,
                                            onPressed: () {
                                              setState(() {
                                                if (infoEntry.withPlayers[1] ==
                                                    players[index]) {
                                                  infoEntry.withPlayers[1] =
                                                      null;
                                                } else {
                                                  infoEntry.withPlayers[1] =
                                                      players[index];
                                                }
                                              });
                                            })),
                              ),
                            ),
                          ]),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Type"),
                          DropdownButton(
                              value: infoEntry.infoEntry.prise,
                              items: Prise.values
                                  .map((e) => DropdownMenuItem<Prise>(
                                      value: e, child: Text(getNomPrise(e))))
                                  .toList(),
                              onChanged: (Prise p) {
                                setState(() {
                                  infoEntry.infoEntry.prise = p;
                                });
                              })
                        ]),
//                        Container(width: 10,
//                          height: 1,
//                        ),
                  ],
                ),
                title: "Attaque",
              ),
              Boxed(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Pour "),
                          DropdownButton<bool>(
                              value: infoEntry.infoEntry.pointsForAttack,
                              items: ["l'attaque", "la défense"]
                                  .map((e) => DropdownMenuItem<bool>(
                                      key: UniqueKey(),
                                      value: e == "l'attaque",
                                      child: Text(e)))
                                  .toList(),
                              onChanged: (bool value) {
                                setState(() {
                                  infoEntry.infoEntry.pointsForAttack = value;
                                });
                              })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints.loose(Size(60, 35)),
                            child: TextFormField(
                              inputFormatters: [HalfDecimalInputFormatter()],
                              initialValue:
                                  infoEntry.infoEntry.points.toString(),
                              onChanged: (String value) {
                                var points =
                                    value.isEmpty ? 0 : double.tryParse(value);
                                infoEntry.infoEntry.points =
                                    (points * 2).round() / 2;
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 10, right: 10),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lightGreen,
                                        width: 2,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(5),
                                    gapPadding: 1),
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                          ),
                          Text(" points"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                              value: infoEntry.infoEntry.nbBouts,
                              items: List.generate(players.length > 5 ? 7 : 4,
                                      (index) => index)
                                  .map((e) => DropdownMenuItem<int>(
                                      key: UniqueKey(),
                                      value: e,
                                      child: Text(e.toString())))
                                  .toList(),
                              onChanged: (int value) {
                                setState(() {
                                  infoEntry.infoEntry.nbBouts = value;
                                  print(infoEntry);
                                });
                              }),
                          Text(
                              " bout${infoEntry.infoEntry.nbBouts != 1 ? "s" : ""}")
                        ],
                      )
                    ],
                  ),
                  title: "Contrat"),
              Boxed(
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                            value: infoEntry.infoEntry.poignees != null &&
                                infoEntry.infoEntry.poignees.isNotEmpty &&
                                infoEntry.infoEntry.poignees[0] != null &&
                                infoEntry.infoEntry.poignees[0] !=
                                    PoigneeType.NONE,
                            onChanged: (bool value) {
                              setState(() {
                                if (infoEntry.infoEntry.poignees == null ||
                                    infoEntry.infoEntry.poignees.isEmpty) {
                                  infoEntry.infoEntry.poignees = [
                                    PoigneeType.SIMPLE
                                  ];
                                }
                                infoEntry.infoEntry.poignees[0] = value
                                    ? PoigneeType.SIMPLE
                                    : PoigneeType.NONE;
                              });
                            }),
                        Text("Poignée "),
                        if (infoEntry.infoEntry.poignees != null &&
                            infoEntry.infoEntry.poignees.isNotEmpty)
                          Expanded(
                            child: DropdownButton(
                                value: infoEntry.infoEntry.poignees[0],
                                isExpanded: true,
                                items: PoigneeType.values
                                    .map(
                                      (e) => DropdownMenuItem<PoigneeType>(
                                          key: UniqueKey(),
                                          value: e,
                                          child: Text(
                                              "${getNamePoignee(e)} (${getNbAtouts(e, players.length)}+ atouts)")),
                                    )
                                    .toList(),
                                onChanged: (poignee) {
                                  setState(() {
                                    infoEntry.infoEntry.poignees[0] = poignee;
                                  });
                                }),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                            value: infoEntry.infoEntry.petitsAuBout != null &&
                                infoEntry.infoEntry.petitsAuBout.isNotEmpty &&
                                infoEntry.infoEntry.petitsAuBout[0] != null &&
                                infoEntry.infoEntry.petitsAuBout[0] !=
                                    Camp.NONE,
                            onChanged: (bool value) {
                              setState(() {
                                if (infoEntry.infoEntry.petitsAuBout == null ||
                                    infoEntry.infoEntry.petitsAuBout.isEmpty) {
                                  infoEntry.infoEntry.petitsAuBout = [
                                    Camp.ATTACK
                                  ];
                                }
                                infoEntry.infoEntry.petitsAuBout[0] =
                                    value ? Camp.ATTACK : Camp.NONE;
                              });
                            }),
                        Text("Petit au bout "),
                        if (infoEntry.infoEntry.petitsAuBout != null &&
                            infoEntry.infoEntry.petitsAuBout.isNotEmpty)
                          DropdownButton(
                              value: infoEntry.infoEntry.petitsAuBout[0],
                              items: Camp.values
                                  .map((e) => DropdownMenuItem(
                                        child: Text(getNameCamp(e)),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (petit) {
                                setState(() {
                                  infoEntry.infoEntry.petitsAuBout[0] = petit;
                                });
                              })
                      ],
                    )
                  ]),
                  title: "Bonus"),
            ],
          ),
        ),
      ),
    );
  }

  bool _validate(InfoEntryPlayerBean infoEntry) {
    if (infoEntry == null) return false;
    if (infoEntry.player == null) return false;
    if (players.length < 5) return true;
    if (infoEntry.withPlayers == null || infoEntry.withPlayers.isEmpty)
      return false;
    if (players.length == 5) return true;
    if (infoEntry.withPlayers.length != 2) return false;
    return true;
  }
}

class AddModifyArguments {
  InfoEntryPlayerBean infoEntry;
  List<Player> players;

  AddModifyArguments({this.infoEntry, @required this.players});
}
