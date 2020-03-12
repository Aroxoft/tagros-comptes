import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/bloc/entry_db_bloc.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/screen/add_modify.dart';

class TableauBody extends StatefulWidget {
  final List<PlayerBean> players;

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
          children: List.generate(
              widget.players.length,
              (index) => Expanded(
                      child: Text(
                    widget.players[index].name.toUpperCase(),
                    textAlign: TextAlign.center,
                  ))),
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
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("No Data"),
              );
            }
            var sums = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(sums.length, (index) {
                  print(widget.players[index]);
                  var sum = sums[widget.players[index].name];
                  return Expanded(
                    child: Text(
                      sum.toStringAsFixed(1),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: sum < 0 ? Colors.red : Colors.green),
                    ),
                  );
                }),
              ),
            );
          }),
      Container(
        constraints: BoxConstraints.expand(height: 4),
        color: Colors.pink,
      ),
      StreamBuilder<List<InfoEntryPlayerBean>>(
        stream: _entriesDbBloc.infoEntries,
        builder: (BuildContext context,
            AsyncSnapshot<List<InfoEntryPlayerBean>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("ERROR: ${snapshot.error}"),
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
            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("No data"),
                ),
              ),
            );
          }
          return Expanded(
            child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  Map<String, double> calculateGain =
                      calculateGains(entries[index], widget.players.toList());
                  var gains = transformGainsToList(
                      calculateGain, widget.players.toList());
                  var key = GlobalKey<SlidableState>();
                  return Slidable(
                    key: key,
                    actionPane: SlidableBehindActionPane(),
                    actionExtentRatio: 0.3333,
//                    dismissal: SlidableDismissal(
//                      child: SlidableDrawerDismissal(),
//                      onWillDismiss: (actionType) =>
//                          actionType == SlideActionType.primary,
//                    ),
                    actions: <Widget>[
                      IconSlideAction(
//                        caption: 'Modifier',
                        color: Colors.amber,
                        icon: Icons.edit,
                        foregroundColor: Colors.white,
                        onTap: () async {
                          var modified = await Navigator.of(context).pushNamed(
                              AddModifyEntry.routeName,
                              arguments: AddModifyArguments(
                                  players: widget.players
                                      .map((e) => PlayerBean.toDb(e))
                                      .toList(),
                                  infoEntry: entries[index]));
                          if (modified != null) {
                            _entriesDbBloc.inModifyEntry.add(modified);
                          }
                        },
                      ),
                    ],
                    secondaryActions: [
                      IconSlideAction(
//                        caption: "Supprimer",
                        color: Colors.red,
                        icon: Icons.delete,
                        foregroundColor: Colors.white,
                        onTap: () {
                          _entriesDbBloc.inDeleteEntry.add(entries[index]);

                          key.currentState.dismiss();
                        },
                      )
                    ],
                    child: Container(
                      color: index % 2 == 1 ? Colors.grey : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(gains.length, (index) {
                            print("Gain[$index] = ${gains[index]}");
                            return Expanded(
                              child: Text(
                                gains[index].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: gains[index] >= 0
                                        ? Colors.grey[850]
                                        : Colors.red[900]),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    ]);
  }
}
