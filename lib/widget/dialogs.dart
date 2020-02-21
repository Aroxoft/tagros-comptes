import 'package:flutter/material.dart';
import 'package:tagros_comptes/types/functions.dart';

showDialogPlayers(BuildContext context, int nbPlayers, DoAfterChosen doAfter) {
  final formKey = GlobalKey<FormState>();
  List<String> players = List(nbPlayers);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Form(
              key: formKey,
              child: ListView.builder(
                  itemCount: nbPlayers * 2,
                  itemBuilder: (BuildContext context, int index) {
                    if (index % 2 == 0) {
                      return Text("Joueur ${(index / 2).floor() + 1}");
                    } else {
                      return TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          if ((players.toList()..remove(value))
                              .contains(value)) {
                            return 'Tous les noms doivent être différents';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          players[(index / 2).floor()] = value;
                        },
                      );
                    }
                  }),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    Navigator.of(context).pop();
                    doAfter(players);
                  }
                },
                child: Text("OK"))
          ],
        );
      });
}
