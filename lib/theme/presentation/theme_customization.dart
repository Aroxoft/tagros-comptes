import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/monetization/domain/premium_plan.dart';
import 'package:tagros_comptes/monetization/presentation/paywall_overlay.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_providers.dart';
import 'package:tagros_comptes/theme/presentation/theme_screen_viewmodel.dart';

const _minFontSizeAppbar = 17;
const _maxFontSizeAppbar = 22;

class ThemeCustomization extends ConsumerWidget {
  const ThemeCustomization({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tiles = _tiles(context,
        themeVM: ref.watch(themeViewModelProvider),
        themeOpt: ref.watch(themeColorProvider).value);
    return PaywallOverlay(
      isPremium: ref.watch(isPremiumProvider.select((value) => value.value == true)),
      child: ListView.builder(
          itemBuilder: (context, index) => tiles[index],
          itemCount: tiles.length),
    );
  }

  Widget _title(String title) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
    );
  }

  Widget _subtitle(String title) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    );
  }

  List<Widget> _tiles(
    BuildContext context, {
    required ThemeScreenViewModel themeVM,
    required ThemeColor? themeOpt,
  }) {
    final theme = themeOpt ?? ThemeColor.defaultTheme();
    final colors = theme.toColors;
    return [
      _title(S.of(context).themeSectionAppScreen),
      TileColorPicker(
          title: S.of(context).themeTitleAppBarColor,
          subtitle: S.of(context).themeSubtitleAppBarColor,
          color: theme.appBarColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(appBarColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleAppBarTextColor,
          subtitle: S.of(context).themeSubtitleAppBarTextColor,
          color: theme.appBarTextColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(appBarTextColor: color));
          },
          context: context),
      ListTile(
        title: Text(S.of(context).themeTitleAppBarFontSize),
        subtitle: Slider(
          value: theme.appBarTextSize,
          min: _minFontSizeAppbar.toDouble(),
          max: _maxFontSizeAppbar.toDouble(),
          divisions: _maxFontSizeAppbar - _minFontSizeAppbar,
          label: theme.appBarTextSize.toStringAsFixed(0),
          onChanged: (value) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(appBarTextSize: value));
          },
        ),
      ),
      ListTile(
        title: Text(S.of(context).themeTitleApplicationBackground),
        subtitle: Text(S.of(context).themeSubtitleApplicationBackground),
        trailing: DropdownButton<bool>(
          value: themeVM.isBackgroundGradient,
          items: [
            DropdownMenuItem(
              value: false,
              child: Text(S.of(context).themeBackgroundChoiceSolid),
            ),
            DropdownMenuItem(
              value: true,
              child: Text(S.of(context).themeBackgroundChoiceGradient),
            ),
          ],
          onChanged: (value) => themeVM.selectBackgroundType(gradient: value!),
        ),
      ),
      if (!themeVM.isBackgroundGradient)
        TileColorPicker(
            title: S.of(context).themeTitleBackgroundColor,
            subtitle: S.of(context).themeSubtitleBackgroundColor,
            color: theme.backgroundColor,
            colorsUsed: colors,
            backgroundColor: theme.averageBackgroundColor,
            onSaved: (Color color) {
              themeVM.updateTheme(
                  newTheme: theme.copyWith(backgroundColor: color));
            },
            context: context),
      if (themeVM.isBackgroundGradient)
        TileColorPicker(
            title: S.of(context).themeTitleGradientFirstColor,
            subtitle: S.of(context).themeSubtitleGradientFirstColor,
            color: theme.backgroundGradient1,
            colorsUsed: colors,
            backgroundColor: theme.averageBackgroundColor,
            onSaved: (color) => themeVM.updateTheme(
                newTheme: theme.copyWith(backgroundGradient1: color)),
            context: context),
      if (themeVM.isBackgroundGradient)
        TileColorPicker(
            title: S.of(context).themeTitleGradientSecondColor,
            subtitle: S.of(context).themeSubtitleGradientSecondColor,
            color: theme.backgroundGradient2,
            colorsUsed: colors,
            backgroundColor: theme.averageBackgroundColor,
            onSaved: (color) => themeVM.updateTheme(
                newTheme: theme.copyWith(backgroundGradient2: color)),
            context: context),
      TileColorPicker(
          title: S.of(context).themeTitleTextColor,
          subtitle: S.of(context).themeSubtitleTextColor,
          color: theme.textColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (color) =>
              themeVM.updateTheme(newTheme: theme.copyWith(textColor: color)),
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleButtonColor,
          subtitle: S.of(context).themeSubtitleButtonsColor,
          color: theme.buttonColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(buttonColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleTextButtonColor,
          subtitle: S.of(context).themeSubtitleTextButtonColor,
          color: theme.textButtonColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(textButtonColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleSliderColor,
          subtitle: S.of(context).themeSubtitleSliderColor,
          color: theme.sliderColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(sliderColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleAccentColor,
          subtitle: S.of(context).themeSubtitleAccentColor,
          color: theme.accentColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(accentColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleActionButtonColor,
          subtitle: S.of(context).themeSubtitleActionButtonColor,
          color: theme.fabColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(fabColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleTextOnActionButtonColor,
          subtitle: S.of(context).themeSubtitleTextOnActionButtonColor,
          color: theme.onFabColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(onFabColor: color));
          },
          context: context),
      const Divider(),
      _title(S.of(context).themeSectionTableScreen),
      _subtitle(S.of(context).themeSubsectionEntry),
      TileColorPicker(
          title: S.of(context).themeTitlePositiveNumberColor,
          subtitle: S.of(context).themeSubtitlePositiveNumberColor,
          color: theme.positiveEntryColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(positiveEntryColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleNegativeNumberColor,
          subtitle: S.of(context).themeSubtitleNegativeNumberColor,
          color: theme.negativeEntryColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(negativeEntryColor: color));
          },
          context: context),
      const Divider(),
      _subtitle(S.of(context).themeSubsectionTotalsLine),
      TileColorPicker(
          title: S.of(context).themeTitlePositiveNumberTitleColor,
          subtitle: S.of(context).themeSubtitlePositiveNumberTitleColor,
          color: theme.positiveSumColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(positiveSumColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleNegativeNumberTitleColor,
          subtitle: S.of(context).themeSubtitleNegativeNumberTitleColor,
          color: theme.negativeSumColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(negativeSumColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleHorizontalLineColor,
          subtitle: S.of(context).themeSubtitleHorizontalLineColor,
          color: theme.horizontalColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(horizontalColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitlePlayerNamesColor,
          subtitle: S.of(context).themeSubtitlePlayerNamesColor,
          color: theme.playerNameColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(playerNameColor: color));
          },
          context: context),
      const Divider(),
      _title(S.of(context).themeSectionAddModifyEntryScreen),
      TileColorPicker(
          title: S.of(context).themeTitleTitlesFrameColor,
          subtitle: S.of(context).themeSubtitleTitlesFrameColor,
          color: theme.frameColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(frameColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleChipColor,
          subtitle: S.of(context).themeSubtitleChipColor,
          color: theme.chipColor,
          colorsUsed: colors,
          backgroundColor: theme.averageBackgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(chipColor: color));
          },
          context: context),
    ];
  }
}

class TileColorPicker extends StatelessWidget {
  const TileColorPicker(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.backgroundColor,
      required this.onSaved,
      required this.colorsUsed,
      required this.context});

  final String title;
  final String subtitle;
  final Color color;
  final Color backgroundColor;
  final void Function(Color color) onSaved;
  final List<Color>? colorsUsed;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: CircleColor(color: color, backgroundColor: backgroundColor),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ColorPickerDialog(
            title: title,
            initialColor: color,
            onSaved: onSaved,
            themeColors: colorsUsed,
          ),
        );
      },
    );
  }
}

class CircleColor extends StatelessWidget {
  const CircleColor({
    super.key,
    required this.color,
    required this.backgroundColor,
    this.size = 35,
  });

  final Color color;
  final Color backgroundColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                offset: const Offset(1, 1),
                color: backgroundColor.isVeryDark
                    ? Colors.white70
                    : Colors.black87,
                blurStyle: BlurStyle.normal)
          ]),
    );
  }
}

class ColorPickerDialog extends HookConsumerWidget {
  final String title;
  final Color initialColor;
  final List<Color>? themeColors;
  final void Function(Color color) onSaved;

  const ColorPickerDialog({
    super.key,
    required this.title,
    required this.initialColor,
    this.themeColors,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = useState(initialColor);
    final history = useState(themeColors ?? <Color>[]);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorPicker(
              colorHistory: history.value,
              hexInputBar: true,
              pickerAreaBorderRadius: BorderRadius.circular(5),
              labelTypes: const [
                ColorLabelType.hsv,
                ColorLabelType.hsl,
                ColorLabelType.rgb
              ],
              pickerColor: color.value,
              portraitOnly: true,
              onHistoryChanged: (value) {
                history.value = value;
              },
              pickerAreaHeightPercent: 0.5,
              enableAlpha: false,
              displayThumbColor: true,
              // colorHistory: themeColors,
              onColorChanged: (value) {
                color.value = value;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(S.of(context).actionCancel),
        ),
        TextButton(
            onPressed: () {
              context.pop();
              onSaved(color.value);
            },
            child: Text(S.of(context).actionSubmit))
      ],
    );
  }
}
