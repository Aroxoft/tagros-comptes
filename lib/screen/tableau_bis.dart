import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/bloc/entry_db_bloc.dart';
import 'package:tagros_comptes/model/game.dart';
import 'package:tagros_comptes/screen/add_modify.dart';
import 'package:tagros_comptes/widget/tableau_body.dart';

class TableauPage extends StatefulWidget {
  final Game game;

  const TableauPage({Key key, @required this.game}) : super(key: key);

  @override
  _TableauPageState createState() => _TableauPageState();
}

class _TableauPageState extends State<TableauPage> {
  EntriesDbBloc _entriesDbBloc;

  @override
  void initState() {
    super.initState();
    _entriesDbBloc = BlocProvider.of<EntriesDbBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.game.nbPlayers} joueurs"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: Colors.pink,
          onPressed: () async {
            final res = await Navigator.of(context).pushNamed(
                AddModifyEntry.routeName,
                arguments: AddModifyArguments(
                    players: widget.game.players,
                    infoEntry: null));
            if (res != null) {
              addEntry(_entriesDbBloc, res);
              Flushbar(
                flushbarStyle: FlushbarStyle.GROUNDED,
                flushbarPosition: FlushbarPosition.BOTTOM,
                title: "Partie ajoutée avec succès",
                duration: Duration(seconds: 2),
                message: res.toString(),
                backgroundGradient: LinearGradient(
                  colors: [Colors.blueGrey, Colors.teal],
                ),
              )
                ..show(context);
              print(res);
            }
          }),
      body: TableauBody(players: widget.game.players),
    );
  }
}
