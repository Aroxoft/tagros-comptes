import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/tagros/data/tableau_repository_impl.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/repository/tableau_repository.dart';

class TableauViewModel extends ChangeNotifier {
  TableauViewModel(this._tableauRepository);

  final TableauRepository _tableauRepository;

  Stream<List<PlayerBean>> get players => _tableauRepository.watchPlayers
      .map((event) => event.players.map((e) => PlayerBean.fromDb(e)).toList());

  Stream<Map<String, double>> get sums => _tableauRepository.watchSums;

  Stream<List<InfoEntryPlayerBean>> get entries =>
      _tableauRepository.watchInfoEntries;

  void modifyEntry(InfoEntryPlayerBean modified) {
    _tableauRepository.modifyEntry(modified);
  }

  void addEntry(InfoEntryPlayerBean info) {
    _tableauRepository.addEntry(info);
  }

  void deleteEntry(int id) {
    _tableauRepository.deleteEntry(id);
  }
}

final tableauViewModelProvider =
    Provider.autoDispose.family<TableauViewModel, int>((ref, gameId) {
  return TableauViewModel(ref.watch(tableauRepositoryProvider(gameId)));
}, dependencies: [tableauRepositoryProvider]);
