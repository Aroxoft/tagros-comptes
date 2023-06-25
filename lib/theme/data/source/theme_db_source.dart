import 'package:drift/drift.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';

part 'theme_db_source.g.dart';

@DriftAccessor(tables: [Themes, Configs], include: {'theme_queries.drift'})
class ThemeDao extends DatabaseAccessor<AppDatabase> with _$ThemeDaoMixin {
  ThemeDao(super.db);

  static const selectedKey = 'selected_theme';

  Future<void> insertBatch(List<ThemeDb> allThemes) async {
    await batch((batch) {
      batch.insertAll(themes, allThemes, mode: InsertMode.insertOrReplace);
      batch.insertAllOnConflictUpdate(configs, [
        ConfigsCompanion.insert(
            key: selectedKey, value: allThemes.first.id.toString())
      ]);
    });
  }

  Stream<List<ThemeDb>> watchAllThemes() => allThemes().watch();

  Future<int> countThemes() async {
    final count = countAll();
    return await (selectOnly(themes)..addColumns([count]))
            .map((row) => row.read(count))
            .getSingleOrNull() ??
        0;
  }

  Future<List<ThemeDb>> getAllThemes() => allThemes().get();

  Future<void> insertTheme(ThemeDb theme) => into(themes).insert(theme);

  Future<void> updateTheme(ThemeDb theme) => update(themes).replace(theme);

  Future<void> deleteTheme(ThemeDb theme) => delete(themes).delete(theme);

  Future<void> deleteAllThemes() => delete(themes).go();

  Future<void> deleteThemeById(int id) =>
      (delete(themes)..where((tbl) => tbl.id.equals(id))).go();

  Future<ThemeDb?> getThemeById(int id) =>
      (select(themes)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Stream<ThemeDb?> watchThemeById(int id) =>
      (select(themes)..where((tbl) => tbl.id.equals(id))).watchSingleOrNull();

  Stream<ThemeDb?> watchSelectedTheme() =>
      selectedTheme().watchSingleOrNull().map((event) => event?.theme);

  Future<void> selectTheme(int id) async {
    await update(configs).write(ConfigsCompanion(
      key: const Value(selectedKey),
      value: Value(id.toString()),
    ));
  }

  Future<int> duplicateTheme(int id) {
    return transaction(() async {
      final theme = await getThemeById(id);
      if (theme == null) {
        return -1;
      }
      final newTheme = theme.toCompanion(true).copyWith(
            id: const Value.absent(),
            name: Value('${theme.name} (copy)'),
            preset: const Value(false),
          );

      final newId = await into(themes).insert(newTheme);
      await selectTheme(newId);
      return newId;
    });
  }
}
