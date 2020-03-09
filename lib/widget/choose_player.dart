import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/data/database.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/widget/selectable_tag.dart';

class ChoosePlayerFormField extends FormField<Player> {
  final List<Player> suggestions;

  ChoosePlayerFormField(this.suggestions, {
    FormFieldSetter<Player> onSaved,
    FormFieldValidator<Player> validator,
    Player initialValue,
    bool autoValidate = false
  }) : super(onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidate: autoValidate,
      builder: (FormFieldState<Player> state) {
        var controller = TextEditingController(text: state.value.name);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: AutoCompleteTextField<Player>(
                        controller: controller,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(contentPadding: EdgeInsets
                            .symmetric(horizontal: 10, vertical: 20),
                            filled: true,
                            hintText: 'Nom du joueur',
                            hintStyle: TextStyle(color: Colors.blueGrey)),
                        itemSubmitted: (p) {
                          state.didChange(p);
                          onSaved(p);
                        },
                        key: GlobalKey(),
                        suggestions: suggestions,
                        itemBuilder: (BuildContext context, Player item) =>
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(item.name, style: TextStyle(
                                  fontSize: 16, color: Colors.amber),),),
                        itemSorter: (a, b) => a.name.compareTo(b.name),
                        itemFilter: (item, query) =>
                            item.name.toLowerCase().startsWith(
                                query.toLowerCase())
                    )
                ),
                IconButton(icon: Icon(Icons.add), onPressed: () async {
                  var text = controller.text;
                  state.didChange(state.value
                    ..name = text);
                  if (suggestions.any((element) => element.name == text)) {
                    // We have this player in DB
                    state.didChange(state.value
                      ..id = suggestions
                          .firstWhere((element) => element.name == text)
                          .id);
                  } else {
                    // Create in DB
                    var id = await DBProvider.db.newPlayer(state.value);
                    state.didChange(state.value
                      ..id = id);
                  }
                })
              ],),
            state.hasError
                ? Text(state.errorText, style: TextStyle(color: Colors.red),)
                : Container(),
            if(state.value != null && state.value.name != null &&
                state.value.name.isNotEmpty) Padding(
              padding: const EdgeInsets.only(top: 4.0,bottom: 8),
              child: SelectableTag(
                  textColor: Colors.white,
                  text: state.value.name, onPressed: () {}),
            )
          ],
        );
      });

}