import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/common/domain/types/functions.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';

class SelectableTag extends ConsumerWidget {
  final String text;
  final OnPressed onPressed;
  final bool selected;

  const SelectableTag(
      {super.key,
      required this.text,
      required this.onPressed,
      this.selected = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(themeColorProvider.select((value) => value
        .maybeWhen(
          data: (data) => data,
          orElse: () => ThemeColor.defaultTheme(),
        )
        .chipColor));
    final textColorSelected = ref.watch(themeColorProvider.select(
        (value) => value.whenOrNull(data: (data) => data.chipTextColor)));
    final textColorUnselected =
        ref.watch(themeColorProvider.select((value) => value.whenOrNull(
              data: (data) {
                return data.averageBackgroundColor.isLight
                    ? Colors.black87
                    : Colors.white70;
              },
            )));
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: selected ? color : Colors.transparent,
              border:
                  Border.all(color: color, style: BorderStyle.solid, width: 2)),
          child: Text(
            text,
            style: TextStyle(
                color: selected ? textColorSelected : textColorUnselected),
          ),
        ),
      ),
    );
  }
}
