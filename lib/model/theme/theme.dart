import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:tagros_comptes/model/theme/colors.dart';

part 'theme.freezed.dart';

part 'theme.g.dart';

@freezed
class ThemeColor extends Comparable<ThemeColor> with _$ThemeColor {
  @HiveType(typeId: 1, adapterName: "ThemeColorAdapter")
  factory ThemeColor({
    @HiveField(0) @Default(Color(0xffbb0179)) Color accentColor,
    @HiveField(1) @Default(Color(0xff1d6592)) Color appBarColor,
    @HiveField(2) @Default(Color(0xfffccf05)) Color buttonColor,
    @HiveField(3) @Default(Color(0xff131313)) Color positiveEntryColor,
    @HiveField(4) @Default(Color(0xffaa1616)) Color negativeEntryColor,
    @HiveField(5) @Default(Color(0xff287202)) Color positiveSumColor,
    @HiveField(6) @Default(Color(0xffad0e0e)) Color negativeSumColor,
    @HiveField(7) @Default(Color(0xffdc1b91)) Color horizontalColor,
    @HiveField(8) @Default(Color(0xff314757)) Color playerNameColor,
    @HiveField(9) @Default(Color(0xff292f38)) Color textColor,
    @HiveField(10) @Default(Color(0xff065800)) Color frameColor,
    @HiveField(11) @Default(Color(0xffb30074)) Color chipColor,
    @HiveField(12) @Default(Color(0xffffffff)) Color backgroundColor,
    @HiveField(13) @Default(Color(0xff231a1a)) Color textButtonColor,
    @HiveField(14) @Default(Color(0xffffffff)) Color appBarTextColor,
    @HiveField(15) @Default(19.0) double appBarTextSize,
    @HiveField(16) @Default(Color(0xffab2779)) Color fabColor,
    @HiveField(17) @Default(Color(0xffffffff)) Color onFabColor,
    @HiveField(18) @Default(Color(0xff38526d)) Color sliderColor,
    @HiveField(19) @Default(Color(0x00ffffff)) Color backgroundGradient1,
    @HiveField(20) @Default(Color(0x00ffffff)) Color backgroundGradient2,
    @HiveField(21) @Default(true) bool preset,
    @HiveField(22) required String name,
    @HiveField(23) @Default(0) int id,
  }) = _ThemeColor;

  ThemeColor._();

  factory ThemeColor.purple() => _ThemeColor(
        name: "Purple",
        id: 1,
        backgroundColor: Colors.transparent,
        appBarColor: kColorPinkSpot1,
        buttonColor: kColorPinkSpot1,
        textButtonColor: kColorPinkSpot3.lighten(0.6),
        appBarTextColor: kColorPinkSpot3.lighten(0.4),
        chipColor: kColorPinkSpot4.lighten(0.5),
        fabColor: kColorPinkSpot4,
        frameColor: kColorPinkSpot2,
        horizontalColor: kColorPinkSpot2,
        negativeEntryColor: kColorPinkNegative,
        positiveEntryColor: kColorPinkPositive,
        negativeSumColor: kColorPinkNegative,
        positiveSumColor: kColorPinkPositive,
        onFabColor: kColorPinkSpot4.lighten(0.7),
        sliderColor: kColorPinkSpot2,
        accentColor: kColorPinkSpot1,
        playerNameColor: kColorPinkSpot1.darken(0.5),
        textColor: kColorPinkSpot1.darken(0.5),
        backgroundGradient1: kColorBrokenHearts1,
        backgroundGradient2: kColorBrokenHearts2,
      );

  factory ThemeColor.corporate() => _ThemeColor(
        name: "Corporate",
        id: 2,
        appBarColor: Colors.blue.shade700,
        chipColor: Colors.blue,
      );

  factory ThemeColor.ocean() => _ThemeColor(
        name: "Ocean",
        id: 3,
        appBarColor: Colors.blue.shade900,
      );

  factory ThemeColor.pastels() => _ThemeColor(
        name: "Pastels",
        id: 4,
        appBarColor: kColorPastel3,
        backgroundGradient1: kColorPastel4,
        backgroundGradient2: kColorPastel5,
        accentColor: kColorPastel3,
        textColor: Colors.black,
        horizontalColor: kColorPastel1,
        chipColor: kColorPastel3,
        frameColor: kColorPastel2,
        fabColor: kColorPastel3,
        onFabColor: Colors.black87,
        appBarTextColor: Colors.black87,
        buttonColor: kColorPastel2,
        textButtonColor: Colors.black54,
        backgroundColor: Colors.transparent,
        playerNameColor: Colors.black87,
        sliderColor: kColorPastel3,
        positiveSumColor: Colors.black87,
        positiveEntryColor: Colors.black87,
        negativeSumColor: kColorPastel3,
        negativeEntryColor: kColorPastel3,
      );

  factory ThemeColor.dark() => _ThemeColor(
        name: "Dark",
        id: 5,
        backgroundGradient1: kColorDark1,
        backgroundGradient2: kColorDark2,
        textColor: Colors.white,
        positiveEntryColor: Colors.white,
        negativeEntryColor: Colors.white,
        positiveSumColor: Colors.white,
        negativeSumColor: Colors.white,
        sliderColor: Colors.white70,
        buttonColor: kColorDark3,
        fabColor: kColorDark5,
        onFabColor: Colors.white70,
        playerNameColor: Colors.white70,
        backgroundColor: Colors.transparent,
        appBarTextColor: kColorDark3,
        frameColor: kColorDark6,
        textButtonColor: kColorDark1,
        chipColor: kColorDark4,
        horizontalColor: kColorDark6,
        accentColor: kColorDark5,
        appBarColor: kColorDark4,
      );

  factory ThemeColor.defaultTheme() => _ThemeColor(name: "Default");

  factory ThemeColor.custom({required String name}) =>
      _ThemeColor(name: name, preset: false);

  Set<Color> get toColors => {
        accentColor,
        appBarColor,
        buttonColor,
        positiveEntryColor,
        negativeEntryColor,
        positiveSumColor,
        negativeSumColor,
        horizontalColor,
        playerNameColor,
        textColor,
        frameColor,
        chipColor,
        if (backgroundColor != Colors.transparent) backgroundColor,
        textButtonColor,
        appBarTextColor,
        fabColor,
        onFabColor,
        sliderColor,
        if (backgroundGradient1 != Colors.transparent) backgroundGradient1,
        if (backgroundGradient2 != Colors.transparent) backgroundGradient2
      };

  ThemeData get toDataTheme {
    return ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: appBarColor,
          titleTextStyle:
              TextStyle(color: appBarTextColor, fontSize: appBarTextSize),
          actionsIconTheme: IconThemeData(color: appBarTextColor),
          iconTheme: IconThemeData(color: appBarTextColor),
        ),
        // for background of dropdown buttons
        canvasColor: averageBackgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: buttonColor,
              onPrimary: textButtonColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        ),
        dialogTheme: DialogTheme(
            backgroundColor: averageBackgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        popupMenuTheme: PopupMenuThemeData(color: averageBackgroundColor),
        sliderTheme: SliderThemeData(
            activeTrackColor: sliderColor,
            thumbColor: sliderColor.darken(0.4),
            activeTickMarkColor:
                sliderColor.isLight ? Colors.black87 : Colors.white70,
            inactiveTickMarkColor:
                sliderColor.isLight ? Colors.black87 : Colors.white70,
            inactiveTrackColor: sliderColor.lighten(0.4)),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(
                sliderColor.isLight ? Colors.black : Colors.white),
            fillColor: MaterialStateProperty.all(sliderColor)),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: fabColor, foregroundColor: onFabColor),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor),
        scaffoldBackgroundColor: backgroundColor,
        listTileTheme: ListTileThemeData(textColor: textColor),
        primaryTextTheme: const TextTheme()
            .apply(bodyColor: textColor, displayColor: textColor),
        dividerTheme: DividerThemeData(color: textColor.withOpacity(0.8)),
        chipTheme: ChipThemeData.fromDefaults(
            primaryColor: chipColor,
            secondaryColor: chipColor,
            labelStyle: TextStyle(color: chipTextColor)),
        textTheme: const TextTheme(
          subtitle1: TextStyle(),
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: textColor,
          displayColor: textColor,
          decorationColor: textColor,
        ));
  }

  Color get averageBackgroundColor {
    if (backgroundColor != Colors.transparent) return backgroundColor;
    return Color.lerp(backgroundGradient1, backgroundGradient2, 0.5)!;
  }

  Color get chipTextColor =>
      chipColor.isLight ? chipColor.darken(0.8) : chipColor.lighten(0.8);

  Color get chipUnselectedTextColor =>
      averageBackgroundColor.isLight ? Colors.black87 : Colors.white70;

  @override
  int compareTo(ThemeColor other) {
    if (preset == other.preset) return name.compareTo(other.name);
    if (preset) {
      return 1;
    } else {
      return -1;
    }
  }
}

class ColorAdapter extends TypeAdapter<Color> {
  @override
  Color read(BinaryReader reader) => Color(reader.readInt());

  @override
  void write(BinaryWriter writer, Color color) => writer.writeInt(color.value);

  @override
  int get typeId => 2;
}

extension ColorUtil on Color {
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final factor = 1 - amount;
    return Color.fromARGB(
      alpha,
      (red * factor).round(),
      (green * factor).round(),
      (blue * factor).round(),
    );
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    return Color.fromARGB(
        alpha,
        red + ((255 - red) * amount).round(),
        green + ((255 - green) * amount).round(),
        blue + ((255 - blue) * amount).round());
  }

  /// HSP color model, as seen in http://alienryderflex.com/hsp.html
  double get brightnessSqr =>
      0.299 * pow(red, 2) + 0.587 * pow(green, 2) + 0.114 * pow(blue, 2);

  /// The color is bright if the brightness is > 127.5 (so with the square, it
  /// corresponds to 127.5*127.5 (16256.25)
  bool get isLight => brightnessSqr > 16256.25;
}
