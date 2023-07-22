import 'package:flutter/material.dart';
import 'package:tagros_comptes/theme/data/source/theme_dao.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_repository.dart';

class ThemeRepositoryImpl extends ThemeRepository {
  ThemeRepositoryImpl(this._themeDao) {
    _initThemes();
  }

  final ThemeDao _themeDao;

  Future<void> _initThemes() async {
    final count = await _themeDao.countThemes();
    if (count == 0) {
      _themeDao
          .insertBatch(ThemeColor.allThemes.map((e) => e.toDbTheme).toList());
    }
  }

  @override
  Stream<ThemeData> get themeData =>
      selectedTheme().map((event) => event.toDataTheme);

  @override
  Future<int> copyTheme({required int id}) {
    return _themeDao.duplicateTheme(id);
  }

  @override
  Future<void> deleteTheme({required int id}) => _themeDao.deleteThemeById(id);

  @override
  Future<void> selectTheme({required int id}) => _themeDao.selectTheme(id);

  @override
  Future<void> updateTheme({required ThemeColor newTheme}) =>
      _themeDao.updateTheme(newTheme.toDbTheme);

  @override
  Stream<List<ThemeColor>> allThemes() =>
      _themeDao.watchAllThemes().map((event) =>
          event.map((theme) => ThemeColor.fromDb(theme: theme)).toList());

  @override
  Stream<ThemeColor> selectedTheme() {
    return _themeDao.watchSelectedTheme().map((event) => event != null
        ? ThemeColor.fromDb(theme: event)
        : ThemeColor.defaultTheme());
  }
}
