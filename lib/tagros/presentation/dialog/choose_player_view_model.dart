import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';
import 'package:tagros_comptes/tagros/domain/game/nb_players.dart';

class ChoosePlayer extends Notifier<(String?, List<Player>)> {
  ChoosePlayer();

  /// The view model for the choose player screen
  /// The state is a tuple of the error message and the list of players
  @override
  (String?, List<Player>) build() => (null, <Player>[]);

  void addPlayer(Player player) {
    state = (state.$1, [...state.$2, player]);
  }

  void removePlayerAt({required int index}) {
    final shrank = state.$2.toList()..removeAt(index);
    state = (state.$1, shrank);
  }

  Future<void> addPlayerByName(String text) async {
    final name = text.trim();
    if (name.isEmpty) {
      return;
    }
    final Player player =
        await ref.read(playerDaoProvider).addOrGetByName(name: name);
    addPlayer(player);
  }

  Future<List<Player>> updateSuggestions({required String query}) {
    return ref.read(playerDaoProvider).searchForPlayer(query,
        notIn: state.$2.map((e) => e.id).nonNulls.toList());
  }

  bool validatePlayers() {
    final nbPlayers = state.$2.length;
    final bool correct =
        NbPlayers.values.map((e) => e.number).contains(nbPlayers);
    String? error;
    if (!correct) {
      error = S.current.errorGameNbPlayers(nbPlayers);
    } else {
      error = null;
    }
    state = (error, state.$2);
    return correct;
  }

  void clear() {
    state = (null, []);
  }
}

final choosePlayerProvider =
    NotifierProvider.autoDispose<ChoosePlayer, (String?, List<Player>)>(() {
  return ChoosePlayer();
  },
  dependencies: [playerDaoProvider],
);
