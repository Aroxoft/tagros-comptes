import 'package:flutter/foundation.dart';
import 'package:tagros_comptes/model/theme/theme.dart';
import 'package:tagros_comptes/services/theme/theme_service.dart';

class ThemeScreenViewModel extends ChangeNotifier {
  ThemeScreenViewModel(this._themeService)
      : _navigationTabIndex = 0,
        _currentTheme = ThemeColor.defaultTheme(),
        _allThemes = _themeService.listenableThemes.value.values.toList()
          ..sort() {
    _themeService.themeStream.listen((event) {
      _currentTheme = event;
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

  List<ThemeColor> get allThemes => _allThemes;
  int _navigationTabIndex;

  int get selectedIndex {
    final i = allThemes.indexWhere((element) => _currentTheme.id == element.id);
    return i == -1 ? 0 : i;
  }

  int get navigationTabIndex => _navigationTabIndex;

  ThemeColor get selectedTheme => _currentTheme;

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
