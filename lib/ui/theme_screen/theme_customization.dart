import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/state/viewmodel/theme_screen_viewmodel.dart';

const _minFontSizeAppbar = 17;
const _maxFontSizeAppbar = 22;

class ThemeCustomization extends ConsumerWidget {
  const ThemeCustomization({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tiles = _tiles(context,
        themeVM: ref.watch(themeViewModelProvider),
        themeOpt: ref.watch(themeColorProvider).value);
    return ListView.builder(
        itemBuilder: (context, index) => tiles[index], itemCount: tiles.length);
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
    return [
      _title("App"),
      TileColorPicker(
          title: S.of(context).themeTitleAppBarColor,
          subtitle: S.of(context).themeSubtitleAppBarColor,
          color: theme.appBarColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(appBarColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleAppBarTextColor,
          subtitle: S.of(context).themeSubttleAppBarTextColor,
          color: theme.appBarTextColor,
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
      TileColorPicker(
          title: S.of(context).themeTitleBackgroundColor,
          subtitle: S.of(context).themeSubtitleBackgroundColor,
          color: theme.backgroundColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(backgroundColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleButtonColor,
          subtitle: S.of(context).themeSubtitleButtonsColor,
          color: theme.buttonColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(buttonColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleTextButtonColor,
          subtitle: S.of(context).themeSubtitleTextButtonColor,
          color: theme.textButtonColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(textButtonColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleSliderColor,
          subtitle: S.of(context).themeSubtitleSliderColor,
          color: theme.sliderColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(sliderColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleAccentColor,
          subtitle: S.of(context).themeSubtitleAccentColor,
          color: theme.accentColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(accentColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleActionButtonColor,
          subtitle: S.of(context).themeSubtitleActionButtonColor,
          color: theme.fabColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(fabColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleTextOnActionButtonColor,
          subtitle: S.of(context).themeSubtitleTextOnActionButtonColor,
          color: theme.onFabColor,
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
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(positiveEntryColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleNegativeNumberColor,
          subtitle: S.of(context).themeSubtitleNegativeNumberColor,
          color: theme.negativeEntryColor,
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
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(positiveSumColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleNegativeNumberTitleColor,
          subtitle: S.of(context).themeSubtitleNegativeNumberTitleColor,
          color: theme.negativeSumColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(negativeSumColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleHorizontalLineColor,
          subtitle: S.of(context).themeSubtitleHorizontalLineColor,
          color: theme.horizontalColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(horizontalColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitlePlayerNamesColor,
          subtitle: S.of(context).themeSubtitlePlayerNamesColor,
          color: theme.playerNameColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(playerNameColor: color));
          },
          context: context),
      const Divider(),
      _title(S.of(context).themeSectionAddmodifyEntryScreen),
      TileColorPicker(
          title: S.of(context).themeTitleTitlesFrameColor,
          subtitle: S.of(context).themeSubtitleTitlesFrameColor,
          color: theme.frameColor,
          onSaved: (Color color) {
            themeVM.updateTheme(newTheme: theme.copyWith(frameColor: color));
          },
          context: context),
      TileColorPicker(
          title: S.of(context).themeTitleChipColor,
          subtitle: S.of(context).themeSubtitleChipColor,
          color: theme.chipColor,
          onSaved: (Color color) {
            themeVM.updateTheme(
                newTheme: theme.copyWith(
                    chipColor: color
                    ));
          },
          context: context),
    ];
  }
}

class TileColorPicker extends StatelessWidget {
  const TileColorPicker(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.onSaved,
      required this.context})
      : super(key: key);
  final String title;
  final String subtitle;
  final Color color;
  final void Function(Color color) onSaved;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: CircleColor(color: color),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ColorPickerDialog(
              title: title, initialColor: color, onSaved: onSaved),
        );
      },
    );
  }
}

class CircleColor extends StatelessWidget {
  const CircleColor({
    Key? key,
    required this.color,
    this.size = 35,
  }) : super(key: key);

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: const [
        BoxShadow(
            blurRadius: 5,
            offset: Offset(1, 1),
            color: Colors.black87,
            blurStyle: BlurStyle.normal)
      ]),
    );
  }
}

class ColorPickerDialog extends HookConsumerWidget {
  final String title;
  final Color initialColor;
  final void Function(Color color) onSaved;

  const ColorPickerDialog({
    Key? key,
    required this.title,
    required this.initialColor,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(8),
      title: Text(title),
      content: MaterialPicker(
        pickerColor: initialColor,
        enableLabel: false,
        portraitOnly: false,
        onColorChanged: onSaved,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onSaved(initialColor);
            },
            child: Text(S.of(context).actionCancel)),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).actionSubmit))
      ],
    );
  }
}
