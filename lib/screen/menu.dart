import 'package:flutter/material.dart';
import 'package:tagros_comptes/model/players.dart';
import 'package:tagros_comptes/screen/tableau.dart';
import 'package:tagros_comptes/widget/dialogs.dart';

class MenuScreen extends StatelessWidget {
  static const routeName = "/menu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Compteur Tagros"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  print("pressed settings");
                })
          ],
        ),
        body: MenuBody()
    );
  }
}

class MenuBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: Players.values.length,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              child: RaisedButton(
                  elevation: 4,
                  color: Colors.amber,
                  onPressed: () {
                    print("show dialogUwwrdrU");
                    showDialogPlayers(
                        context, getNumber(Players.values[index]),
                            (List<String> players) {
                          print("chose: $players");
                          Navigator.of(context).pushNamed(
                              Tableau.routeName, arguments: TableauArguments(
                              players));
                        });
                  },
                  child: Text("${getNumber(Players.values[index])} players")),
            );
          }),
    );
  }
}
