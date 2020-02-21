import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tagros_comptes/bloc/entry_bloc.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';
import 'package:tagros_comptes/screen/add_modify.dart';

class Tableau extends StatelessWidget {
  static const String routeName = "/tableau";

  @override
  Widget build(BuildContext context) {
    // extract players
    final TableauArguments args = ModalRoute.of(context).settings.arguments;
    entryBloc().setPlayers(args.players);
    return Scaffold(
      appBar: AppBar(
        title: Text("${args.players.length} joueurs"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final res = await Navigator.of(context).pushNamed(
                AddModifyEntry.routeName,
                arguments: AddModifyArguments(
                    infoEntry: null, players: args.players));
            entryBloc().add(res);

            print(res);
          }),
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

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
                widget.players.length, (index) =>
                Text(widget.players[index].toUpperCase())),
          ),
        ),
        Container(constraints: BoxConstraints.expand(height: 10),
          color: Colors.red,
        ),

        StreamBuilder(
          stream: entryBloc().sum,
          builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text("Error: ${snapshot.error}"),);
            }
            var sums = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(sums.length, (index) {
                  var sum = sums[widget.players[index]];
                  return Text(sum.toStringAsFixed(1), style: TextStyle(
                      color: sum < 0 ? Colors.red : Colors.green),);
                }),),
            );
          },),
        Container(constraints: BoxConstraints.expand(height: 10),
          color: Colors.red,
        ),

        StreamBuilder(
            stream: entryBloc().entries,
            builder: (BuildContext context,
                AsyncSnapshot<List<InfoEntry>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("ERROR"),
                  ),);
              }
              if (!snapshot.hasData) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("No data"),
                ),);
              }
              var entries = snapshot.data;
              if (entries == null || entries.isEmpty) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("No data"),
                ),);
              }
              return Expanded(
                child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      HashMap<String, double> calculateGain = calculateGains(
                          entries[index], widget.players);
                      var gains = transformGainsToList(
                          calculateGain, widget.players);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              gains.length, (index) =>
                              Text(gains[index].toString(), style: TextStyle(
                                  color: gains[index] >= 0
                                      ? Colors.grey
                                      : Colors.red),)),
                        ),
                      );
                    }),
              );
            }),
      ],
    );
  }
}
