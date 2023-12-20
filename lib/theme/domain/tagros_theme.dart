import 'package:flutter/material.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';

@immutable
class TagrosTheme extends ThemeExtension<TagrosTheme> {
  final ThemeColor themeColor;

  const TagrosTheme({required this.themeColor});

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: themeColor.appBarColor,
        primary: themeColor.buttonColor,
        onPrimary: themeColor.chipColor,
        onPrimaryContainer: themeColor.chipColor,
        primaryContainer: themeColor.chipColor,
        secondary: themeColor.accentColor,
        onSecondary: themeColor.chipColor,
        secondaryContainer: themeColor.chipColor,
      ),
    );
  }

  @override
  ThemeExtension<TagrosTheme> lerp(
      covariant ThemeExtension<TagrosTheme>? other, double t) {
    if (other is! TagrosTheme) return this;
    return TagrosTheme(themeColor: themeColor.lerp(other.themeColor, t));
  }

  @override
  ThemeExtension<TagrosTheme> copyWith({ThemeColor? themeColor}) {
    return TagrosTheme(themeColor: themeColor ?? this.themeColor);
  }
}
