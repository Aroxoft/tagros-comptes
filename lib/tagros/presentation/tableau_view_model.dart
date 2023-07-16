import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/game_provider.dart';
import 'package:tagros_comptes/tagros/data/tableau_repository_impl.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/repository/tableau_repository.dart';
import 'package:tagros_comptes/tagros/presentation/add_modify.dart';

part 'tableau_view_model.g.dart';

class TableauViewModel {
  TableauViewModel(this._tableauRepository, this.ref);

  final Ref ref;
  final TableauRepository _tableauRepository;

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
    final modified = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: const AddModifyEntry(),
      ),
      settings:
          RouteSettings(arguments: AddModifyArguments(infoEntry: infoEntry)),
    ));
    return modified as InfoEntryPlayerBean?;
  }
}

@Riverpod(dependencies: [tableauRepository])
TableauViewModel? tableauViewModel(TableauViewModelRef ref) {
  final repository = ref.watch(tableauRepositoryProvider);
  if (repository == null) return null;
  return TableauViewModel(repository, ref);
}

@Riverpod(dependencies: [gamesDao])
Future<GameWithPlayers> fetchGameWithPlayers(
    FetchGameWithPlayersRef ref, int gameId) async {
  final gameDao = ref.watch(gamesDaoProvider);
  return gameDao.fetchGameWithPlayers(gameId: gameId);
}

@Riverpod(dependencies: [CurrentGameId, fetchGameWithPlayers])
AsyncValue<GameWithPlayers> currentGame(CurrentGameRef ref) {
  return ref.watch(currentGameIdProvider).maybeMap(data: (id) {
    final asyncValue = ref.watch(fetchGameWithPlayersProvider(id.value));
    return asyncValue;
  }, orElse: () {
    return const AsyncLoading();
  });
}
