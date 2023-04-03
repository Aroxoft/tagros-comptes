import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/util/list_util.dart';

part 'theme.freezed.dart';
part 'theme.g.dart';

@freezed
class ThemeColor extends Comparable<ThemeColor> with _$ThemeColor {
  @HiveType(typeId: 1, adapterName: "ThemeColorAdapter")
  factory ThemeColor({
    @HiveField(0) @Default(Color(0xff861313)) Color accentColor,
    @HiveField(1) @Default(Color(0xff393a3e)) Color appBarColor,
    @HiveField(2) @Default(Color(0xff861313)) Color buttonColor,
    @HiveField(3) @Default(Color(0xff393a3e)) Color positiveEntryColor,
    @HiveField(4) @Default(Color(0xff861313)) Color negativeEntryColor,
    @HiveField(5) @Default(Color(0xff246305)) Color positiveSumColor,
    @HiveField(6) @Default(Color(0xff861313)) Color negativeSumColor,
    @HiveField(7) @Default(Color(0xff393a3e)) Color horizontalColor,
    @HiveField(8) @Default(Color(0xff393a3e)) Color playerNameColor,
    @HiveField(9) @Default(Color(0xff292f38)) Color textColor,
    @HiveField(10) @Default(Color(0xff375161)) Color frameColor,
    @HiveField(11) @Default(Color(0xff393a3e)) Color chipColor,
    @HiveField(12) @Default(Color(0x00000000)) Color backgroundColor,
    @HiveField(13) @Default(Color(0xffffffff)) Color textButtonColor,
    @HiveField(14) @Default(Color(0xffffffff)) Color appBarTextColor,
    @HiveField(15) @Default(19.0) double appBarTextSize,
    @HiveField(16) @Default(Color(0xff861313)) Color fabColor,
    @HiveField(17) @Default(Color(0xffffffff)) Color onFabColor,
    @HiveField(18) @Default(Color(0xff323747)) Color sliderColor,
    @HiveField(19) @Default(Color(0xffeee9e4)) Color backgroundGradient1,
    @HiveField(20) @Default(Color(0xffe7e1d4)) Color backgroundGradient2,
    @HiveField(21) @Default(true) bool preset,
    @HiveField(22) required String name,
    @HiveField(23) @Default(0) int id,
  }) = _ThemeColor;

  ThemeColor._();

  factory ThemeColor.defaultTheme() =>
      _ThemeColor(name: S.current.themeNameClassic);

  factory ThemeColor.purple() => _ThemeColor(
        name: S.current.themeNamePurple,
        accentColor: const Color(0xff7f135b),
        appBarColor: const Color(0xff7f135b),
        buttonColor: const Color(0xffbf698a),
        positiveEntryColor: const Color(0xff005b47),
        negativeEntryColor: const Color(0xffd22165),
        positiveSumColor: const Color(0xff005b47),
        negativeSumColor: const Color(0xffd22165),
        horizontalColor: const Color(0xff9c6182),
        playerNameColor: const Color(0xff400a2e),
        textColor: const Color(0xff400a2e),
        frameColor: const Color(0xff9c6182),
        chipColor: const Color(0xff80e4d6),
        backgroundColor: const Color(0x00000000),
        textButtonColor: const Color(0xff414041),
        appBarTextColor: const Color(0xffffeffd),
        appBarTextSize: 19.0,
        fabColor: const Color(0xff00c9ac),
        onFabColor: const Color(0xffb3efe6),
        sliderColor: const Color(0xff9c6182),
        backgroundGradient1: const Color(0xffd9a7c7),
        backgroundGradient2: const Color(0xfffffcdc),
        id: 1,
        preset: true,
      );

  factory ThemeColor.corporate() => _ThemeColor(
        name: S.current.themeNameCorporate,
        accentColor: const Color(0xffbb0179),
        appBarColor: const Color(0xff1976d2),
        buttonColor: const Color(0xfffccf05),
        positiveEntryColor: const Color(0xff131313),
        negativeEntryColor: const Color(0xffaa1616),
        positiveSumColor: const Color(0xff287202),
        negativeSumColor: const Color(0xffad0e0e),
        horizontalColor: const Color(0xffdc1b91),
        playerNameColor: const Color(0xff314757),
        textColor: const Color(0xff292f38),
        frameColor: const Color(0xff065800),
        chipColor: const Color(0xff2196f3),
        backgroundColor: const Color(0xffffffff),
        textButtonColor: const Color(0xff231a1a),
        appBarTextColor: const Color(0xffffffff),
        appBarTextSize: 19.0,
        fabColor: const Color(0xffab2779),
        onFabColor: const Color(0xffffffff),
        sliderColor: const Color(0xff38526d),
        backgroundGradient1: const Color(0x00ffffff),
        backgroundGradient2: const Color(0x00ffffff),
        id: 2,
        preset: true,
      );

  factory ThemeColor.chocolate() => _ThemeColor(
        name: S.current.themeNameChocolate,
        accentColor: const Color(0xff362222),
        appBarColor: const Color(0xff362222),
        buttonColor: const Color(0xffb3541e),
        positiveEntryColor: const Color(0xff362222),
        negativeEntryColor: const Color(0xffb3541e),
        positiveSumColor: const Color(0xff362222),
        negativeSumColor: const Color(0xffb3541e),
        horizontalColor: const Color(0xffb3541e),
        playerNameColor: const Color(0xff362222),
        textColor: const Color(0xff362222),
        frameColor: const Color(0xff362222),
        chipColor: const Color(0xffb3541e),
        backgroundColor: const Color(0x00000000),
        textButtonColor: const Color(0xffffeded),
        appBarTextColor: const Color(0xffffffff),
        appBarTextSize: 19.0,
        fabColor: const Color(0xffb3541e),
        onFabColor: const Color(0xffffeded),
        sliderColor: const Color(0xffb3541e),
        backgroundGradient1: const Color(0xffffece5),
        backgroundGradient2: const Color(0xffe4cfc7),
        id: 6,
        preset: true,
      );

  factory ThemeColor.hacker() => _ThemeColor(
        name: S.current.themeNameHacker,
        accentColor: const Color(0xff34ff00),
        appBarColor: const Color(0xff34ff00),
        buttonColor: const Color(0xff34ff00),
        positiveEntryColor: const Color(0xff0bff00),
        negativeEntryColor: const Color(0xffff008f),
        positiveSumColor: const Color(0xff0bff00),
        negativeSumColor: const Color(0xffff008f),
        horizontalColor: const Color(0xff0bff00),
        playerNameColor: const Color(0xff0bff00),
        textColor: const Color(0xff34ff00),
        frameColor: const Color(0xff0bff00),
        chipColor: const Color(0xff0bff00),
        backgroundColor: const Color(0x00000000),
        textButtonColor: const Color(0xff000000),
        appBarTextColor: const Color(0xff000000),
        appBarTextSize: 22.0,
        fabColor: const Color(0xff34ff00),
        onFabColor: const Color(0xff131313),
        sliderColor: const Color(0xff34ff00),
        backgroundGradient1: const Color(0xff1f221b),
        backgroundGradient2: const Color(0xff234307),
        id: 3,
        preset: true,
      );

  factory ThemeColor.blackWhite() => _ThemeColor(
        name: S.current.themeNameBlackWhite,
        accentColor: const Color(0xff393939),
        appBarColor: const Color(0xff393939),
        buttonColor: const Color(0xff1f1f1f),
        positiveEntryColor: const Color(0xff1f1f1f),
        negativeEntryColor: const Color(0xff898989),
        positiveSumColor: const Color(0xff1f1f1f),
        negativeSumColor: const Color(0xff898989),
        horizontalColor: const Color(0xff898989),
        playerNameColor: const Color(0xff1f1f1f),
        textColor: const Color(0xff1f1f1f),
        frameColor: const Color(0xff1f1f1f),
        chipColor: const Color(0xff1f1f1f),
        backgroundColor: const Color(0x00000000),
        textButtonColor: const Color(0xffffffff),
        appBarTextColor: const Color(0xffffffff),
        appBarTextSize: 19.0,
        fabColor: const Color(0xff393939),
        onFabColor: const Color(0xffffffff),
        sliderColor: const Color(0xff898989),
        backgroundGradient1: const Color(0xffffffff),
        backgroundGradient2: const Color(0xffe0e0e0),
        id: 7,
        preset: true,
      );

  factory ThemeColor.pastels() => _ThemeColor(
        name: S.current.themeNamePastels,
        accentColor: const Color(0xffffafcc),
        appBarColor: const Color(0xffffe3ea),
        buttonColor: const Color(0xffffe3ea),
        positiveEntryColor: const Color(0xdd000000),
        negativeEntryColor: const Color(0xffffafcc),
        positiveSumColor: const Color(0xdd000000),
        negativeSumColor: const Color(0xffffafcc),
        horizontalColor: const Color(0xffcdb4db),
        playerNameColor: const Color(0xffac6580),
        textColor: const Color(0xff000000),
        frameColor: const Color(0xffafbfe1),
        chipColor: const Color(0xffffafcc),
        backgroundColor: const Color(0x00000000),
        textButtonColor: const Color(0xff827777),
        appBarTextColor: const Color(0xff904747),
        appBarTextSize: 19.0,
        fabColor: const Color(0xffffafcc),
        onFabColor: const Color(0xdd000000),
        sliderColor: const Color(0xffffafcc),
        backgroundGradient1: const Color(0xfff8ffff),
        backgroundGradient2: const Color(0xffedf3ff),
        id: 4,
        preset: true,
      );

  factory ThemeColor.dark() => _ThemeColor(
        name: S.current.themeNameDark,
        accentColor: const Color(0xffffffff),
        appBarColor: const Color(0xff344a53),
        buttonColor: const Color(0xff98afba),
        positiveEntryColor: const Color(0xffffffff),
        negativeEntryColor: const Color(0xffffffff),
        positiveSumColor: const Color(0xffffffff),
        negativeSumColor: const Color(0xffffffff),
        horizontalColor: const Color(0xff7b6553),
        playerNameColor: const Color(0xb3ffffff),
        textColor: const Color(0xffffffff),
        frameColor: const Color(0xff7b6553),
        chipColor: const Color(0xff344a53),
        backgroundColor: const Color(0x00000000),
        textButtonColor: const Color(0xff232526),
        appBarTextColor: const Color(0xff98afba),
        appBarTextSize: 19.0,
        fabColor: const Color(0xff4a3626),
        onFabColor: const Color(0xb3ffffff),
        sliderColor: const Color(0xb3ffffff),
        backgroundGradient1: const Color(0xff232526),
        backgroundGradient2: const Color(0xff414345),
        id: 5,
        preset: true,
      );

  factory ThemeColor.custom({required String name}) =>
      _ThemeColor(name: name, preset: false);

  String get toCodeString => '''
factory ThemeColor.${name.replaceAll(RegExp("[^a-zA-Z0-9]"), "").toLowerCase()}() => _ThemeColor(name: "$name", 
accentColor: const $accentColor,
appBarColor: const $appBarColor,
buttonColor: const $buttonColor,
positiveEntryColor: const $positiveEntryColor,
negativeEntryColor: const $negativeEntryColor,
positiveSumColor: const $positiveSumColor,
negativeSumColor: const $negativeSumColor,
horizontalColor: const $horizontalColor,
playerNameColor: const $playerNameColor,
textColor: const $textColor,
frameColor: const $frameColor,
chipColor: const $chipColor,
backgroundColor: const $backgroundColor,
textButtonColor: const $textButtonColor,
appBarTextColor: const $appBarTextColor,
appBarTextSize: $appBarTextSize,
fabColor: const $fabColor,
onFabColor: const $onFabColor,
sliderColor: const $sliderColor,
backgroundGradient1: const $backgroundGradient1,
backgroundGradient2: const $backgroundGradient2,
id: $id,
preset: true,);''';

  List<Color> get toColors => [
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
        backgroundColor,
        textButtonColor,
        appBarTextColor,
        fabColor,
        onFabColor,
        sliderColor,
        backgroundGradient1,
        backgroundGradient2
      ]
          .where((element) => element.opacity > 0)
          .unique(toId: (element) => element.value)
          .toList();

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
        tabBarTheme: TabBarTheme(
            labelColor: appBarTextColor,
            unselectedLabelColor: appBarTextColor.withOpacity(0.8)),
        iconTheme: IconThemeData(color: textColor),
        primaryIconTheme: IconThemeData(color: textColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: textButtonColor,
              backgroundColor: buttonColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: textColor)),
        dialogTheme: DialogTheme(
            backgroundColor: averageBackgroundColor,
            titleTextStyle:
                TextStyle(color: textColor, fontSize: appBarTextSize),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        inputDecorationTheme: InputDecorationTheme(
          focusColor: accentColor,
          hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: textColor),
              borderRadius: BorderRadius.circular(5)),
          suffixIconColor: accentColor,
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          iconColor: accentColor,
          prefixIconColor: accentColor,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: accentColor),
              borderRadius: BorderRadius.circular(5)),
          filled: true,
          fillColor:
              averageBackgroundColor.isLight ? Colors.black12 : Colors.white12,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: accentColor,
          selectionColor: accentColor,
          selectionHandleColor: accentColor,
        ),
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
        chipTheme: ChipThemeData(
            backgroundColor: chipColor,
            brightness: Brightness.dark,
            selectedColor: chipColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            deleteIconColor: chipTextColor,
            padding: EdgeInsets.zero,
            disabledColor: chipColor.withAlpha(127),
            secondarySelectedColor: chipColor,
            pressElevation: 0,
            // primaryColor: chipColor,
            // secondaryColor: chipColor,
            labelStyle: TextStyle(color: chipTextColor),
            secondaryLabelStyle: TextStyle(color: chipTextColor)),
        textTheme: const TextTheme(
          titleMedium: TextStyle(),
          bodyLarge: TextStyle(),
          bodyMedium: TextStyle(),
        ).apply(
          bodyColor: textColor,
          displayColor: textColor,
          decorationColor: textColor,
        ));
  }

  Color get averageBackgroundColor {
    if (backgroundColor.opacity != 0) return backgroundColor;
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

  /// is brightness < 63 ?
  bool get isVeryDark => brightnessSqr < 4032;
}
