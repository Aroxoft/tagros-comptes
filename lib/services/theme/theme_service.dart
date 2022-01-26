import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeData;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tagros_comptes/model/theme/theme.dart';

class ThemeService {
  static const themeBox = 'themeBox';
  static const optionsBox = 'optionsBox';
  static const keyCurrent = 'keyCurrentTheme';

  ThemeService()
      : _box = Hive.box<ThemeColor>(themeBox),
        _themeController = BehaviorSubject.seeded(ThemeColor.defaultTheme()),
        _optionsBox = Hive.box(optionsBox) {
    _initThemes();
    _updateThemeController.stream.listen(_handleUpdateTheme);
    _copyThemeController.stream.listen(_handleCopyTheme);
    _selectThemeController.stream.listen(_handleSelectTheme);
    _deleteThemeController.stream.listen(_handleDeleteTheme);
  }

  final _updateThemeController = StreamController<ThemeColor>.broadcast();
  final _copyThemeController = StreamController<ThemeColor>.broadcast();
  final _selectThemeController = StreamController<ThemeColor>.broadcast();
  final _deleteThemeController = StreamController<ThemeColor>.broadcast();

  final BehaviorSubject<ThemeColor> _themeController;

  Stream<ThemeColor> get themeStream => _themeController.stream;

  StreamSink<ThemeColor> get modifyTheme => _updateThemeController.sink;

  StreamSink<ThemeColor> get copyTheme => _copyThemeController.sink;

  StreamSink<ThemeColor> get selectTheme => _selectThemeController.sink;

  StreamSink<ThemeColor> get deleteTheme => _deleteThemeController.sink;

  void _initThemes() {
    if (_box.isEmpty) {
      // put all themes here
      _box.put(0, ThemeColor.defaultTheme());
      _box.put(1, ThemeColor.purple());
      _box.put(2, ThemeColor.corporate());
      _box.put(3, ThemeColor.hacker());
      _box.put(4, ThemeColor.pastels());
      _box.put(5, ThemeColor.dark());
      _box.put(6, ThemeColor.chocolate());
      _box.put(7, ThemeColor.blackWhite());
    }
    _themeController.value =
        _box.get(_currentId, defaultValue: ThemeColor.defaultTheme())!;
  }

  int get _currentId => _optionsBox.get(keyCurrent, defaultValue: 0) as int;

  final Box<ThemeColor> _box;
  final Box<dynamic> _optionsBox;

  Stream<ThemeData> get themeData =>
      _themeController.map((event) => event.toDataTheme);

  ValueListenable<Box<ThemeColor>> get listenableThemes => _box.listenable();

  Future<void> _handleUpdateTheme(ThemeColor event) async {
    await _box.put(event.id, event);
    _themeController.add(event);
  }

  void _handleSelectTheme(ThemeColor event) {
    _optionsBox.put(keyCurrent, event.id);
    _themeController.add(event);
  }

  Future<void> _handleCopyTheme(ThemeColor event) async {
    final copy = event.copyWith(name: "${event.name} (copy)");
    final id = await _box.add(copy);
    final toStore = copy.copyWith(id: id, preset: false);
    await _box.put(id, toStore);
    _optionsBox.put(keyCurrent, id);
    _themeController.add(toStore);
  }

  void dispose() {
    _box.close();
    _themeController.close();
    _updateThemeController.close();
    _copyThemeController.close();
    _deleteThemeController.close();
    _selectThemeController.close();
  }

  Future<void> _handleDeleteTheme(ThemeColor event) async {
    if (event.id == _optionsBox.get(keyCurrent)) {
      _optionsBox.put(keyCurrent, 0);
      _themeController.add(_box.get(_optionsBox.get(keyCurrent))!);
    }
    await _box.delete(event.id);
  }
}
