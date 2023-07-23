import 'package:flutter/material.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';

abstract class ThemeRepository {
  Stream<ThemeData> get themeData;

  Stream<List<ThemeColor>> allThemes();

  Stream<ThemeColor> selectedTheme();

  Future<void> selectTheme({required int id});

  Future<void> updateTheme({required ThemeColor newTheme});

  Future<int> copyTheme({required int id});

  Future<void> deleteTheme({required int id});
}
