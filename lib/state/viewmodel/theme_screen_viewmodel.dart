import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_service.dart';

class ThemeScreenViewModel extends ChangeNotifier {
  ThemeScreenViewModel(this._themeService)
      : _navigationTabIndex = 0,
        _currentTheme = ThemeColor.defaultTheme(),
        _isBackgroundGradient = false,
        _allThemes = _themeService.listenableThemes.value.values.toList()
          ..sort() {
    _themeService.themeStream.listen((event) {
      if (kDebugMode) {
        print("newTheme!\n${event.toCodeString}");
      }
      _currentTheme = event;
      _isBackgroundGradient = event.backgroundColor.opacity == 0;
      notifyListeners();
    });
    _themeService.listenableThemes.addListener(() {
      _allThemes = _themeService.listenableThemes.value.values.toList()..sort();
      notifyListeners();
    });
  }

  ThemeColor _currentTheme;
  final ThemeService _themeService;
  List<ThemeColor> _allThemes;
  bool _isBackgroundGradient;

  List<ThemeColor> get allThemes => _allThemes;

  bool get isBackgroundGradient => _isBackgroundGradient;
  int _navigationTabIndex;

  int get selectedIndex {
    final i = allThemes.indexWhere((element) => _currentTheme.id == element.id);
    return i == -1 ? 0 : i;
  }

  int get navigationTabIndex => _navigationTabIndex;

  ThemeColor get selectedTheme => _currentTheme;

  T _fallback<T>(
      {required T value1,
      required T value2,
      required T defaultValue,
      required bool Function(T value) isForbidden}) {
    assert(!isForbidden(defaultValue),
        "The default value should not be a forbidden value");
    if (!isForbidden(value1)) return value1;
    if (!isForbidden(value2)) return value2;
    return defaultValue;
  }

  void selectBackgroundType({required bool gradient}) {
    _isBackgroundGradient = gradient;
    if (gradient) {
      // set the solid color to transparent
      // and set the gradient colors to non transparent values
      final g1 = _fallback<Color>(
        value1: _currentTheme.backgroundGradient1,
        value2: _currentTheme.backgroundColor,
        defaultValue: Colors.white,
        isForbidden: (value) => value.opacity == 0,
      );
      final g2 = _fallback<Color>(
        value1: _currentTheme.backgroundGradient2,
        value2: _currentTheme.backgroundColor,
        defaultValue: Colors.white,
        isForbidden: (value) => value.opacity == 0,
      );
      _themeService.modifyTheme.add(_currentTheme.copyWith(
          backgroundColor: Colors.transparent,
          backgroundGradient1: g1,
          backgroundGradient2: g2));
    } else {
      // set the solid color to a non transparent color
      final bg = _fallback<Color>(
        value1: _currentTheme.backgroundGradient1,
        value2: _currentTheme.backgroundGradient2,
        defaultValue: Colors.white,
        isForbidden: (value) => value.opacity == 0,
      );
      _themeService.modifyTheme
          .add(_currentTheme.copyWith(backgroundColor: bg));
    }
    // notifyListeners();
  }

  void changeTab(int index) {
    _navigationTabIndex = index;
    notifyListeners();
  }

  void selectTheme(int index) {
    _themeService.selectTheme.add(allThemes[index]);
  }

  void updateTheme({required ThemeColor newTheme}) {
    _themeService.modifyTheme.add(newTheme);
  }

  void copyTheme({required int index}) {
    _themeService.copyTheme.add(allThemes[index]);
  }

  void deleteTheme({required int index}) {
    _themeService.deleteTheme.add(allThemes[index]);
  }
}
