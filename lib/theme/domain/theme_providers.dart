import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/theme/data/theme_repository_impl.dart';
import 'package:tagros_comptes/theme/domain/theme.dart';
import 'package:tagros_comptes/theme/domain/theme_repository.dart';

part 'theme_providers.g.dart';

@Riverpod(keepAlive: true, dependencies: [database])
ThemeRepository themeRepository(ThemeRepositoryRef ref) =>
    ThemeRepositoryImpl(ref.watch(databaseProvider).themeDao);

@Riverpod(dependencies: [themeRepository])
Stream<ThemeData> themeData(ThemeDataRef ref) {
  return ref.watch(themeRepositoryProvider.select((value) => value.themeData));
}

@Riverpod(dependencies: [themeRepository])
Stream<ThemeColor> themeColor(ThemeColorRef ref) =>
    ref.watch(themeRepositoryProvider.select((value) => value.selectedTheme()));
