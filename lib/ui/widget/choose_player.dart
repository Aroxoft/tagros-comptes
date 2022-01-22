import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/state/providers.dart';

class ChoosePlayer extends HookConsumerWidget {
  const ChoosePlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TypeAheadField<Player?>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: textEditingController,
                  decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      hintText: S.of(context).hintSearchPlayer),
                ),
                suggestionsCallback: (pattern) => ref.watch(choosePlayerProvider
                    .select((value) => value.updateSuggestions(pattern))),
                itemBuilder: (context, Player? itemData) {
                  if (itemData == null) return const SizedBox();
                  return ListTile(
                    title: Text(itemData.pseudo),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade200, shape: BoxShape.circle),
                      child: Text(itemData.id.toString()),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) {
                  return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(S.of(context).chooseDialogNoItemsFound),
                      ));
                },
                debounceDuration: const Duration(milliseconds: 500),
                getImmediateSuggestions: true,
                onSuggestionSelected: (suggestion) {
                  if (suggestion != null) {
                    ref.read(choosePlayerProvider).addPlayer(suggestion);
                  }
                },
              ),
            ),
            IconButton(
                onPressed: () async {
                  ref
                      .read(choosePlayerProvider)
                      .checkForPseudoInDb(textEditingController.text);
                  textEditingController.clear();
                },
                icon: const Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}
