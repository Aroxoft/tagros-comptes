import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';
import 'package:tagros_comptes/calculous/poignee.dart';
import 'package:tagros_comptes/widget/selectable_tag.dart';

class AddModifyEntry extends StatefulWidget {
  static String routeName = "/addModify";

  @override
  _AddModifyEntryState createState() => _AddModifyEntryState();
}

class _AddModifyEntryState extends State<AddModifyEntry> {
  InfoEntry infoEntry;
  bool add;
  List<String> players;

  @override
  void initState() {
    infoEntry = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (infoEntry == null) {
      final AddModifyArguments args = ModalRoute
          .of(context)
          .settings
          .arguments;
      infoEntry = args.infoEntry;
      players = args.players;
      add = false;
      if (infoEntry == null) {
        add = true;
        infoEntry = InfoEntry(player: players[0], points: 0, nbBouts: 0);
        if (players.length == 5) {
          infoEntry.withPlayers = [players[0]];
        } else if (players.length > 5) {
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
            Navigator.of(context).pop(infoEntry);
          }),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2,),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 18.0, left: 10, right: 10, bottom: 20),
                    child: Column(
                      children: <Widget>[Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                flex: 2,
                                child: Text("Preneur")),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: players.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return SelectableTag(
                                        selected: infoEntry.player ==
                                            players[index],
                                        text: players[index], onPressed: () {
                                      setState(() {
                                        if (infoEntry.player ==
                                            players[index]) {
                                          infoEntry.player = null;
                                        } else {
                                          infoEntry.player = players[index];
                                        }
                                      });
                                    });
                                  },),
                              ),
                            ),
                          ]),
                        if(players.length >= 5) Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "Partenaire${players.length > 5
                                      ? " numéro 1"
                                      : ""}"),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                    players.length,
                                    itemBuilder: (BuildContext context,
                                        int index) =>
                                    SelectableTag(
                                        selected: infoEntry.withPlayers[0] ==
                                            players[index],
                                        text: players[index], onPressed: () {
                                      setState(() {
                                        if (infoEntry.withPlayers[0] ==
                                            players[index]) {
                                          infoEntry.withPlayers[0] = null;
                                        } else {
                                          infoEntry.withPlayers[0] =
                                          players[index];
                                        }
                                      });
                                    })),
                              ),
                            ),
                          ])
                        ,
                        if(players.length > 5) Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                  "Partenaire numéro 2"),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: players.length,
                                    itemBuilder: (BuildContext context,
                                        int index) =>
                                        SelectableTag(
                                            selected: infoEntry
                                                .withPlayers[1] ==
                                                players[index],
                                            text: players[index],
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
                            ]),
//                        Container(width: 10,
//                          height: 1,
//                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  left: 20,
                  top: 10,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    color: Colors.white,
                    child: Text("Attaque"),
                  ))
            ]
            ),
            Stack(children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Padding(padding: const EdgeInsets.only(
                      top: 18, right: 10, left: 10, bottom: 20),
                    child: Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Pour "),
                          DropdownButton(
                              value: infoEntry.pointsForAttack,
                              items: ["l'attaque", "la défense"].map((e) =>
                                  DropdownMenuItem<bool>(
                                      key: UniqueKey(),
                                      value: e == "l'attaque",
                                      child: Text(e))).toList(),
                              onChanged: (bool value) {
                                setState(() {
                                  infoEntry.pointsForAttack = value;
                                });
                              })
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            constraints: BoxConstraints.loose(Size(30, 30)),
                            child: TextFormField(
                              initialValue: infoEntry.points.toString(),
                              onChanged: (String value) {
                                infoEntry.points = double.tryParse(value);
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                          ),
                          Text(" points"),
                        ],),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          DropdownButton(
                              value: infoEntry.nbBouts,
                              items: List.generate(
                                  players.length > 5 ? 7 : 4, (index) => index)
                                  .map((e) =>
                                  DropdownMenuItem<int>(
                                      key: UniqueKey(),
                                      value: e,
                                      child: Text(e.toString()))).toList(),
                              onChanged: (int value) {
                                print("selected $value");
                                setState(() {
                                  infoEntry.nbBouts = value;
                                  print(infoEntry);
                                });
                              }),
                          Text(" bout${infoEntry.nbBouts != 1 ? "s" : ""}")
                        ],)
                    ],),),
                ),),
              Positioned(
                  left: 20,
                  top: 10,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    color: Colors.white,
                    child: Text("Contrat"),
                  ))
            ],),

            Stack(children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 20),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Padding(padding: const EdgeInsets.only(
                          top: 18, right: 10, left: 10, bottom: 20),
                          child: Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(value: infoEntry.poignees != null &&
                                    infoEntry.poignees.isNotEmpty &&
                                    infoEntry.poignees[0] != null &&
                                    infoEntry.poignees[0] != PoigneeType.NONE,
                                    onChanged: (bool value) {
                                      setState(() {
                                        if (infoEntry.poignees == null ||
                                            infoEntry.poignees.isEmpty) {
                                          infoEntry.poignees =
                                          [PoigneeType.SIMPLE];
                                        }
                                        if (value) {
                                          infoEntry.poignees[0] =
                                              PoigneeType.SIMPLE;
                                        }
                                        if (!value) {
                                          infoEntry.poignees[0] =
                                              PoigneeType.NONE;
                                        }
                                      });
                                    }),
                                Text("Poignée "),
                                if(infoEntry.poignees != null &&
                                    infoEntry.poignees
                                        .isNotEmpty) DropdownButton(
                                    value: infoEntry.poignees[0],
                                    items: PoigneeType.values.map((e) =>
                                        DropdownMenuItem<PoigneeType>(
                                            key: UniqueKey(),
                                            value: e,
                                            child: Text(getNamePoignee(e))
                                        ),
                                    ).toList(),
                                    onChanged: (poignee) {
                                      setState(() {
                                        infoEntry.poignees[0] = poignee;
                                      });
                                    }),
                                if(infoEntry.poignees != null &&
                                    infoEntry.poignees
                                        .isNotEmpty) Text(
                                    "(${getNbAtouts(infoEntry.poignees[0],
                                        players.length)}+ atouts)")
                              ],
                            ),
                          ])))
              ),
              Positioned(child: Container(
                  padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  color: Colors.white,
                  child: Text("Bonus")),
                left: 20,
                top: 10,)
            ])


          ],
        ),
      ),
    );
  }
}

class AddModifyArguments {
  InfoEntry infoEntry;
  List<String> players;

  AddModifyArguments({this.infoEntry, @required this.players});
}
