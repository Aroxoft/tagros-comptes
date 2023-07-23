import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';

class PlayerSearchField extends HookConsumerWidget {
  const PlayerSearchField({
    super.key,
    required this.onAdd,
    required this.onSelected,
    required this.searchForPlayer,
  });

  final void Function(String name) onAdd;
  final void Function(Player player) onSelected;
  final Future<Iterable<Player>> Function(String) searchForPlayer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = useState(TextEditingController());
    final focusNode = useState(FocusNode());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Autocomplete<Player>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              final text = textEditingValue.text.toLowerCase();
              if (text.isEmpty) {
                return const Iterable<Player>.empty();
              }
              return searchForPlayer(text);
            },
            optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<Player> onSelected,
                    Iterable<Player> options) =>
                LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                height: 200.0 * options.length,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    elevation: 8.0,
                    child: SizedBox(
                      width: constraints.maxWidth * 0.7,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Player player = options.elementAt(index);
                          return ListTile(
                            title: Text(player.pseudo),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              child: Text("${player.id}"),
                            ),
                            onTap: () {
                              onSelected(player);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            onSelected: (value) {
              onSelected(value);
              textController.value.clear();
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                textController.value = fieldTextEditingController;
                focusNode.value = fieldFocusNode;
              });
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                onSubmitted: (String value) {
                  onAdd(value);
                  fieldTextEditingController.clear();
                  fieldFocusNode.requestFocus();
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: S.of(context).hintSearchPlayer,
                  suffixIcon: const Icon(Icons.search),
                ),
              );
            },
            optionsMaxHeight: 400,
          ),
        ),
        IconButton(
            onPressed: () {
              onAdd(textController.value.text);
              textController.value.clear();
              focusNode.value.requestFocus();
            },
            icon: const Icon(Icons.add)),
      ],
    );
  }
}
