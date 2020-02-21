import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';

class Tableau extends StatelessWidget {
  static const String routeName = "/tableau";

  @override
  Widget build(BuildContext context) {
    // extract players
    final TableauArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("${args.players.length} joueurs"),
      ),
      body: TableauBody(args.players),
    );
  }
}

class TableauArguments {
  List<String> players;

  TableauArguments(this.players);
}

class TableauBody extends StatefulWidget {
  final List<String> players;

  TableauBody(this.players);

  @override
  _TableauBodyState createState() => _TableauBodyState();
}

class _TableauBodyState extends State<TableauBody> {
  List<InfoEntry> entries;

  @override
  void initState() {
    super.initState();
    entries = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        [Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
              widget.players.length, (index) => Text(widget.players[index])),
        )
        ],
        List.generate(
            entries.length,
                (index) {
              HashMap<String, int> calculateGain = calculateGains(
                  entries[index], widget.players);
              var gains = transformGainsToList(
                  calculateGain, widget.players);
              return Row(
                children: List.generate(
                    gains.length, (index) =>
                    Text(gains[index].toString(), style: TextStyle(
                        color: gains[index] > 0 ? Colors.grey : Colors.red),)),
              );
            })
      ].expand((e) => e).toList(),
    );
  }
}
