import 'package:flutter/material.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/bloc/entry_db_bloc.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/model/info_entry.dart';

class TableauPage extends StatefulWidget {
  @override
  _TableauPageState createState() => _TableauPageState();
}

class _TableauPageState extends State<TableauPage> {
  EntriesDbBloc _entriesDbBloc;
  var players = ["A", "B", "C", "D"];

  @override
  void initState() {
    super.initState();
    _entriesDbBloc = BlocProvider.of<EntriesDbBloc>(context);
  }

  void _addEntry() async {
    InfoEntry entry = InfoEntry(player: "A", points: 35, nbBouts: 2);
    _entriesDbBloc.inAddEntry.add(entry);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<InfoEntry>>(
      stream: _entriesDbBloc.entries,
      builder: (BuildContext context, AsyncSnapshot<List<InfoEntry>> snapshot) {
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
        return Expanded(
          child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, double> calculateGain =
                    calculateGains(entries[index], players);
                var gains = transformGainsToList(calculateGain, players);
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
              }),
        );
      },
    );
  }
}
