import 'package:flutter/material.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/bloc/entry_db_bloc.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/player.dart';

class TableauBody extends StatefulWidget {
  final List<Player> players;

  const TableauBody({Key key, @required this.players}) : super(key: key);

  @override
  _TableauBodyState createState() => _TableauBodyState();
}

class _TableauBodyState extends State<TableauBody> {
  EntriesDbBloc _entriesDbBloc;

  @override
  void initState() {
    super.initState();
    _entriesDbBloc = BlocProvider.of<EntriesDbBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.players.length,
                  (index) => Text(widget.players[index].name.toUpperCase())),
        ),
      ),
      Container(
        constraints: BoxConstraints.expand(height: 4),
        color: Colors.pink,
      ),
      StreamBuilder(
          stream: _entriesDbBloc.sum,
          builder: (context, AsyncSnapshot<Map<String, double>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"),);
            }
            if (!snapshot.hasData) {
              return Center(child: Text("No Data"),);
            }
            var sums = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(sums.length, (index) {
                  print(widget.players[index].name);
                  var sum = sums[widget.players[index].name];
                  return Text(sum.toStringAsFixed(1), style: TextStyle(
                      color: sum < 0 ? Colors.red : Colors.green),);
                }),),
            );
          }),
      Container(
        constraints: BoxConstraints.expand(height: 4),
        color: Colors.pink,
      ),
      StreamBuilder<List<InfoEntry>>(
        stream: _entriesDbBloc.entries,
        builder:
            (BuildContext context, AsyncSnapshot<List<InfoEntry>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ERROR"),
              ),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No data"),
              ),
            );
          }
          var entries = snapshot.data;
          if (entries == null || entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No data"),
              ),
            );
          }
          return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, double> calculateGain =
                calculateGains(
                    entries[index], widget.players.toList());
                var gains = transformGainsToList(
                    calculateGain, widget.players.toList());
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        gains.length,
                        (index) => Text(
                              gains[index].toString(),
                              style: TextStyle(
                                  color: gains[index] >= 0
                                      ? Colors.grey
                                      : Colors.red),
                            )),
                  ),
                );
              });
        },
      ),
    ]);
  }
}
