import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';

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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Que s'est-il passé ?"),
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
                    DropdownButton(
                        value: infoEntry.player,
                        items: players.map((e) =>
                            DropdownMenuItem<String>(
                                key: UniqueKey(),
                                value: e,
                                child: Text(e))).toList(),
                        onChanged: (String value) {
                          print("selected $value");
                          setState(() {
                            infoEntry.player = value;
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
                      constraints: BoxConstraints.loose(Size(500, 30)),
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
    );
  }
}

class AddModifyArguments {
  InfoEntry infoEntry;
  List<String> players;

  AddModifyArguments({this.infoEntry, @required this.players});
}
