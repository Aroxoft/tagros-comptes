import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/types/functions.dart';
import 'package:tagros_comptes/widget/choose_player.dart';

showDialogPlayers(BuildContext context, int nbPlayers, DoAfterChosen doAfter) {
  final formKey = GlobalKey<FormState>();
  List<String> players = List(nbPlayers);
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        List<TextEditingController> controllers = List.generate(
            nbPlayers, (index) => TextEditingController());
        List<GlobalKey<AutoCompleteTextFieldState<Player>>> keys = List
            .generate(nbPlayers, (index) => GlobalKey());
        return AlertDialog(
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              List.generate(nbPlayers * 3, (int index) {
                if (index % 3 == 0) {
                  return Text("Joueur ${(index / 3).floor() + 1}",
                    style: TextStyle(fontSize: 16,),);
                } else if (index % 3 == 1) {
                  return TextFormField(
                    controller: controllers[(index / 3).floor()],
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      if ((players.toList()
                        ..remove(value))
                          .contains(value)) {
                        return 'Tous les noms doivent être différents';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      players[(index / 3).floor()] = value;
                    },
                  );
                } else {
                  FutureBuilder<List<Player>>(
                    future: DBProvider.db.getPlayers(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Player>> snapshot) {
                      if (snapshot.hasError || !snapshot.hasData) {
                        return Container();
                      }
                      var i = (index / 3).floor();
                      return AutoCompleteTextField<Player>(
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              filled: true,
                              hintText: 'Nom du joueur',
                              hintStyle: TextStyle(color: Colors.blueGrey)),
                          itemSubmitted: (p) {
                            controllers[i].text = p.name;
                          },
                          key: keys[i],
                          suggestions: snapshot.data,
                          itemBuilder: (context, item) =>
                              Text(item.name, style: TextStyle(fontSize: 16)),
                          itemSorter: (a, b) => a.name.compareTo(b.name),
                          itemFilter: (item, query) =>
                              item.name.toLowerCase().startsWith(query
                                  .toLowerCase())
                      );
                    },);
                  return ChoosePlayer();
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
