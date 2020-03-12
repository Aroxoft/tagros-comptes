import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/widget/selectable_tag.dart';

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
              var controller = TextEditingController(text: state.value.pseudo);
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
                                  await checkForPseudoInDb(
                                      controller.text, state, suggestions);
                                  onSaved(state.value);
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
                                await checkForPseudoInDb(
                                    p.pseudo, state, suggestions);
                                onSaved(p);
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
                            await checkForPseudoInDb(
                                controller.text, state, suggestions);
                            onSaved(state.value);
                          })
                    ],
                  ),
                  state.hasError
                      ? Text(
                          state.errorText,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container(),
                  if (state.value != null &&
                      state.value.pseudo != null &&
                      state.value.pseudo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
                      child: SelectableTag(
                          textColor: Colors.white,
                          text: state.value.pseudo,
                          onPressed: () {}),
                    )
                ],
              );
            });
  static checkForPseudoInDb(String text, FormFieldState<Player> state,
      List<Player> suggestions) async {
    if (suggestions.any((element) => element.pseudo.trim() == text.trim())) {
      // We have this player in DB
      state.didChange(
          suggestions.firstWhere((element) => element.pseudo.trim() == text.trim()));
    } else {
      // Create in DB
      var player = Player(id: null, pseudo: text.trim());
      var id = await MyDatabase.db.newPlayer(player: player);
      state.didChange(player.copyWith(id: id));
    }
  }
}
