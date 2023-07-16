import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/theme/presentation/theme_customization.dart';

class PresetThemes extends ConsumerWidget {
  const PresetThemes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themesVM = ref.watch(themeViewModelProvider);
    final themes = themesVM.allThemes;
    return ListView.separated(
        itemBuilder: (context, index) {
          final theme = themes[index];
          return ListTile(
            leading: Checkbox(
              value: themesVM.selectedId == theme.id,
              onChanged: (value) {
                if (value ?? false) {
                  themesVM.selectTheme(theme.id);
                }
              },
            ),
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(theme.name)),
                Expanded(
                  child: Row(
                    children: theme.toColors
                        .take(5)
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(right: 2, left: 2),
                              child: CircleColor(
                                color: e,
                                size: 15,
                                backgroundColor: themesVM
                                    .selectedTheme.averageBackgroundColor,
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            onTap: () => themesVM.selectTheme(theme.id),
            trailing: PopupMenuButton<_OptionsTheme>(
              onSelected: (value) {
                switch (value) {
                  case _OptionsTheme.rename:
                    showDialog(
                        context: context,
                        builder: (context) => RenameDialog(
                            initialName: theme.name,
                            onSave: (name) => themesVM.updateTheme(
                                newTheme: theme.copyWith(name: name))));
                  case _OptionsTheme.copy:
                    themesVM.copyTheme(id: theme.id);
                  case _OptionsTheme.delete:
                    themesVM.deleteTheme(id: theme.id);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                    value: _OptionsTheme.rename,
                    child: Row(
                      children: [
                        const Icon(Icons.edit),
                        Text(S.of(context).themeOptionRename)
                      ],
                    )),
                PopupMenuItem(
                  value: _OptionsTheme.copy,
                  child: Row(children: [
                    const Icon(Icons.copy),
                    Text(S.of(ctx).actionCopy)
                  ]),
                ),
                if (!theme.preset)
                  PopupMenuItem(
                    value: _OptionsTheme.delete,
                    child: Row(
                      children: [
                        const Icon(Icons.delete_forever),
                        Text(S.of(ctx).actionDelete),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: themes.length);
  }
}

class RenameDialog extends HookWidget {
  const RenameDialog({
    super.key,
    required this.initialName,
    required this.onSave,
  });

  final String initialName;
  final void Function(String name) onSave;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("in rename dialog");
    }
    final textController = useTextEditingController(text: initialName);
    return AlertDialog(
      title: Text(S.of(context).themeRenameDialogTitle),
      content: TextField(
        controller: textController,
      ),
      actions: [
        TextButton(
            onPressed: () {
              onSave(textController.text);
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).themeRenameDialogActionSave))
      ],
    );
  }
}

enum _OptionsTheme { rename, delete, copy }
