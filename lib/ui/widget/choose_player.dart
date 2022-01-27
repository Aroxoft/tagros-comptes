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
              child: TypeAheadField<Player>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: textEditingController,
                  onSubmitted: (value) {
                    if (textEditingController.text.isNotEmpty) {
                      ref
                          .read(choosePlayerProvider)
                          .checkForPseudoInDb(textEditingController.text);
                      textEditingController.clear();
                    }
                  },
                  textInputAction: TextInputAction.go,
                  decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      // border: const OutlineInputBorder(),
                      hintText: S.of(context).hintSearchPlayer),
                ),
                // autoFlipDirection: true,
                animationDuration: const Duration(milliseconds: 300),
                animationStart: 0.25,
                keepSuggestionsOnLoading: true,
                minCharsForSuggestions: 1,
                loadingBuilder: (context) => const CircularProgressIndicator(),
                suggestionsCallback: (pattern) => ref.watch(choosePlayerProvider
                    .select((value) => value.updateSuggestions(pattern))),
                itemBuilder: (context, Player itemData) {
                  return ListTile(
                    title: Text(itemData.pseudo),
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).textTheme.bodyText2?.color,
                      child: Text(
                        itemData.id.toString(),
                        style: TextStyle(
                            color: ref.watch(themeColorProvider.select(
                                (value) => value.whenOrNull(
                                    data: (data) =>
                                        data.averageBackgroundColor)))),
                      ),
                    ),
                  );
                },
                noItemsFoundBuilder: (context) {
                  return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          S.of(context).chooseDialogNoItemsFound,
                          textAlign: TextAlign.center,
                        ),
                      ));
                },
                debounceDuration: const Duration(milliseconds: 300),
                getImmediateSuggestions: true,
                onSuggestionSelected: (suggestion) {
                  ref.read(choosePlayerProvider).addPlayer(suggestion);
                  textEditingController.clear();
                },
              ),
            ),
            IconButton(
                onPressed: () async {
                  if (textEditingController.text.isNotEmpty) {
                    ref
                        .read(choosePlayerProvider)
                        .checkForPseudoInDb(textEditingController.text);
                    textEditingController.clear();
                  }
                },
                icon: const Icon(Icons.add)),
          ],
        ),
      ],
    );
  }
}
