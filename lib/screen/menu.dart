import 'package:flutter/material.dart';
import 'package:tagros_comptes/model/players.dart';

class MenuScreen extends StatelessWidget {
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
      body: Center(
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
                      print("show dialog");
                    },
                    child: Text("${getNumber(Players.values[index])} players")),
              );
            }),
      ),
    );
  }
}
