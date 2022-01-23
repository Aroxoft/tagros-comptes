import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/ui/theme_screen/theme_customization.dart';

class PresetThemes extends ConsumerWidget {
  const PresetThemes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themesVM = ref.watch(themeViewModelProvider);
    final themes = themesVM.allThemes;
    return ListView.separated(
        itemBuilder: (context, index) {
          final theme = themes[index];
          return ListTile(
            leading: Checkbox(
              value: themesVM.selectedIndex == index,
              onChanged: (value) {
                if (value ?? false) {
                  themesVM.selectTheme(index);
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
                              child: CircleColor(color: e, size: 15),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            onTap: () => themesVM.selectTheme(index),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(children: [
                    const Icon(Icons.copy),
                    Text(S.of(context).actionCopy)
                  ]),
                  onTap: () => themesVM.copyTheme(index: index),
                ),
                if (!theme.preset)
                  PopupMenuItem(
                    child: Row(
                      children: [
                        const Icon(Icons.delete_forever),
                        Text(S.of(context).actionDelete),
                      ],
                    ),
                    onTap: () => themesVM.deleteTheme(index: index),
                  ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: themes.length);
  }
}
