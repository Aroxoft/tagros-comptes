import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_repository.dart';

class ThemeScreenViewModel extends ChangeNotifier {
  ThemeScreenViewModel(this._themeRepository)
      : _navigationTabIndex = 0,
        _currentTheme = ThemeColor.defaultTheme(),
        _isBackgroundGradient = false,
        _allThemes = [] {
    _themeRepository.selectedTheme().listen((event) {
      if (kDebugMode) {
        print("newTheme!\n${event.toCodeString}");
      }
      _currentTheme = event;
      _isBackgroundGradient = event.backgroundColor.opacity == 0;
      notifyListeners();
    });
    _themeRepository.allThemes().listen((event) {
      _allThemes = event..sort();
      notifyListeners();
    });
  }

  ThemeColor _currentTheme;
  final ThemeRepository _themeRepository;
  List<ThemeColor> _allThemes;
  bool _isBackgroundGradient;

  List<ThemeColor> get allThemes => _allThemes;

  bool get isBackgroundGradient => _isBackgroundGradient;
  int _navigationTabIndex;

  int get selectedId => _currentTheme.id;

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
      _themeRepository.updateTheme(
          newTheme: _currentTheme.copyWith(
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
      _themeRepository.updateTheme(
          newTheme: _currentTheme.copyWith(backgroundColor: bg));
    }
  }

  void changeTab(int index) {
    _navigationTabIndex = index;
    notifyListeners();
  }

  void selectTheme(int id) {
    _themeRepository.selectTheme(id: id);
  }

  void updateTheme({required ThemeColor newTheme}) {
    _themeRepository.updateTheme(newTheme: newTheme);
  }

  void copyTheme({required int id}) {
    _themeRepository.copyTheme(id: id);
  }

  void deleteTheme({required int id}) {
    _themeRepository.deleteTheme(id: id);
  }
}
