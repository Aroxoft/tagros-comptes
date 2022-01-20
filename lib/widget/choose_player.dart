// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tagros_comptes/services/db/app_database.dart';

/*
class ChoosePlayerFormField extends FormField<Player> {
  final List<Player> suggestions;

  ChoosePlayerFormField(this.suggestions,
      {required FormFieldSetter<Player> onSaved,
      required FormFieldValidator<Player> validator,
      required Player initialValue,
      bool autoValidate = false})
      : super(
      onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
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
                    state.errorText!,
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
*/
class AutocompleteFormField extends FormField<Player> {
  final List<Player> suggestions;

  AutocompleteFormField(this.suggestions,
      {required FormFieldSetter<Player> onSaved,
      required FormFieldValidator<Player> validator,
      required Player initialValue,
      required MyDatabase database,
      bool autoValidate = false})
      : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<Player> state) {
            var controller = TextEditingController();
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TypeAheadField<Player>(
                        suggestionsCallback: (pattern) {
                          if (pattern.isEmpty) return [];
                          return suggestions.where((element) => element.pseudo
                              .toLowerCase()
                              .contains(pattern.toLowerCase()));
                        },
                        textFieldConfiguration:
                            TextFieldConfiguration(controller: controller),
                        itemBuilder: (context, suggestion) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              suggestion.pseudo,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.amber),
                            ),
                          );
                        },
                        onSuggestionSelected: (Player option) async {
                          final player = await _checkForPseudoInDb(
                              option.pseudo, state, suggestions,
                              database: database);
                          onSaved(player);
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          final p = await _checkForPseudoInDb(
                              controller.text, state, suggestions,
                              database: database);
                          onSaved(p);
                        },
                        icon: Icon(Icons.add))
                  ],
                ),
                state.hasError
                    ? Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
              ],
            );
          },
        );

  static Future<Player> _checkForPseudoInDb(
      String text, FormFieldState<Player> state, List<Player> suggestions,
      {required MyDatabase database}) async {
    Player added;
    if (suggestions.any((element) => element.pseudo.trim() == text.trim())) {
      // We have this player in DB
      added = suggestions
          .firstWhere((element) => element.pseudo.trim() == text.trim());
    } else {
      // Create in DB
      var player = Player(id: null, pseudo: text.trim());
      var id = await database.newPlayer(player: player);
      added = player.copyWith(id: id);
    }
    state.didChange(added);

    return added;
  }
}
