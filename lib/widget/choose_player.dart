import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database_moor.dart';

class ChoosePlayerFormField extends FormField<Player> {
  final List<Player> suggestions;

  ChoosePlayerFormField(this.suggestions,
      {FormFieldSetter<Player> onSaved,
      FormFieldValidator<Player> validator,
      Player initialValue,
      bool autoValidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidate: autoValidate,
            builder: (FormFieldState<Player> state) {
              var controller = TextEditingController();
              var key = GlobalKey<AutoCompleteTextFieldState<Player>>();
              var changed = false;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                          child: AutoCompleteTextField<Player>(
                              controller: controller,
                              onFocusChanged: (focused) async {
                                if (!focused && !changed) {
                                  var player = await checkForPseudoInDb(
                                      controller.text, state, suggestions);
                                  onSaved(player);
                                }
                                changed = false;
                              },
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  filled: true,
                                  hintText: 'Nom du joueur',
                                  hintStyle: TextStyle(color: Colors.blueGrey)),
                              itemSubmitted: (p) async {
                                controller.text = p.pseudo;
                                changed = true;
                                var player = await checkForPseudoInDb(
                                    p.pseudo, state, suggestions);
                                onSaved(player);
                              },
                              key: key,
                              suggestions: suggestions,
                              itemBuilder:
                                  (BuildContext context, Player item) =>
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          item.pseudo,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.amber),
                                        ),
                                      ),
                              itemSorter: (a, b) =>
                                  a.pseudo.compareTo(b.pseudo),
                              itemFilter: (item, query) => item.pseudo
                                  .toLowerCase()
                                  .startsWith(query.toLowerCase()))),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            var p = await checkForPseudoInDb(
                                controller.text, state, suggestions);
                            onSaved(p);
                          })
                    ],
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                ],
              );
            });
  static Future<Player> checkForPseudoInDb(String text,
      FormFieldState<Player> state, List<Player> suggestions) async {
    Player added;
    if (suggestions.any((element) => element.pseudo.trim() == text.trim())) {
      // We have this player in DB
      added = suggestions
          .firstWhere((element) => element.pseudo.trim() == text.trim());
    } else {
      // Create in DB
      var player = Player(id: null, pseudo: text.trim());
      var id = await MyDatabase.db.newPlayer(player: player);
      added = player.copyWith(id: id);
    }
    state.didChange(added);

    return added;
  }
}
