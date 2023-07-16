import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/domain/game/nb_players.dart';

part 'choose_player_view_model.g.dart';

@riverpod
class ChoosePlayer extends _$ChoosePlayer {
  ChoosePlayer();

  /// The view model for the choose player screen
  /// The state is a tuple of the error message and the list of players
  @override
  (String?, UnmodifiableListView<Player>) build() =>
      (null, UnmodifiableListView([]));

  void addPlayer(Player player) {
    state = (state.$1, UnmodifiableListView([...state.$2, player]));
  }

  void removePlayerAt({required int index}) {
    state = (state.$1, UnmodifiableListView([...state.$2..removeAt(index)]));
  }

  Future<void> addPlayerByName(String text) async {
    final Player player =
        await ref.read(playerDaoProvider).addOrGetByName(name: text);
    addPlayer(player);
  }

  Future<List<Player>> updateSuggestions({required String query}) async {
    return ref.read(playerDaoProvider).searchForPlayer(query,
        notIn: state.$2.map((e) => e.id).whereNotNull().toList());
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
    state = (null, UnmodifiableListView([]));
  }
}
