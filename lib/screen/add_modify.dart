import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';
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
            Text("Récapitulatif",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(infoEntry.pointsForAttack
                    ? "Pour l'attaque"
                    : "Pour la défense"),
                Checkbox(
                    value: infoEntry.pointsForAttack,
                    onChanged: (bool value) {
                      print("points attack: $value");
                      setState(() {
                        infoEntry.pointsForAttack = value;
                      });
                    })
              ],),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Preneur"),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Wrap(
                            alignment: WrapAlignment.end,
                            runSpacing: 8,
                            spacing: 4,
                            children: List.generate(players.length, (index) {
                              return SelectableTag(
                                  selected: infoEntry.player ==
                                      players[index],
                                  text: players[index], onPressed: () {
                                setState(() {
                                  if (infoEntry.player == players[index]) {
                                    infoEntry.player = null;
                                  } else {
                                    infoEntry.player = players[index];
                                  }
                                });
                              });
                            },),
                          ),
                        ),
                      ),
                    ],),
                  if(players.length >= 5) Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          "Partenaire${players.length > 5 ? " numéro 1" : ""}"),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Wrap(alignment: WrapAlignment.end,
                          runSpacing: 8, spacing: 4,
                          children: List.generate(players.length, (index) =>
                              SelectableTag(
                                  selected: infoEntry.withPlayers[0] ==
                                      players[index],
                                  text: players[index], onPressed: () {
                                setState(() {
                                  if (infoEntry.withPlayers[0] ==
                                      players[index]) {
                                    infoEntry.withPlayers[0] = null;
                                  } else {
                                    infoEntry.withPlayers[0] = players[index];
                                  }
                                });
                              })),
                        ),
                      )
                    ],
                  ),
                  if(players.length > 5) Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                          "Partenaire numéro 2"),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Wrap(alignment: WrapAlignment.end,
                          runSpacing: 8, spacing: 4,
                          children: List.generate(players.length, (index) =>
                              SelectableTag(
                                  selected: infoEntry.withPlayers[1] ==
                                      players[index],
                                  text: players[index], onPressed: () {
                                setState(() {
                                  if (infoEntry.withPlayers[1] ==
                                      players[index]) {
                                    infoEntry.withPlayers[1] = null;
                                  } else {
                                    infoEntry.withPlayers[1] = players[index];
                                  }
                                });
                              })),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text("Nombre de bouts"),
                      DropdownButton(
                          value: infoEntry.nbBouts,
                          items: List.generate(players.length > 5 ? 7 : 4, (
                              index) => index).map((e) =>
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
                          })
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text("Points"),
                      Container(
                        constraints: BoxConstraints.loose(Size(50, 30)),
                        child: TextFormField(
                          initialValue: infoEntry.points.toString(),
                          onChanged: (String value) {
                            infoEntry.points = int.tryParse(value);
                          },
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),),
                      )
                    ],)
                ],
              ),
            ),
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
