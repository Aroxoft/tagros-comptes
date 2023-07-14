import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/tableau_repository_impl.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/repository/tableau_repository.dart';
import 'package:tagros_comptes/tagros/presentation/add_modify.dart';

class TableauViewModel {
  TableauViewModel(this._tableauRepository, this.ref);

  final Ref ref;
  final TableauRepository _tableauRepository;

  int get gameId => _tableauRepository.gameId;

  Stream<GameWithPlayers> get gameWithPlayers =>
      _tableauRepository.watchPlayers;

  Stream<List<PlayerBean>> get players => gameWithPlayers
      .map((event) => event.players.map((e) => PlayerBean.fromDb(e)).toList());

  Stream<int> get nbPlayers => players.map((event) => event.length);

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

  Future<InfoEntryPlayerBean?> navigateToAddModify(BuildContext context,
      {required InfoEntryPlayerBean? infoEntry}) async {
    final game = ref.read(gameProvider);
    final modified = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProviderScope(
        overrides: [
          gameProvider.overrideWithValue(game),
        ],
        child: const AddModifyEntry(),
      ),
      settings:
          RouteSettings(arguments: AddModifyArguments(infoEntry: infoEntry)),
    ));
    return modified as InfoEntryPlayerBean?;
  }
}

final tableauViewModelProvider = Provider.autoDispose<TableauViewModel>((ref) {
  final gameId = ref.watch(gameProvider.select((value) => value.game.id.value));
  return TableauViewModel(ref.watch(tableauRepositoryProvider(gameId)), ref);
}, dependencies: [tableauRepositoryProvider, gameProvider]);
