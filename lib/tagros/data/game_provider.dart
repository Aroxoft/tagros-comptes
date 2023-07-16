import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';

part 'game_provider.g.dart';

@Riverpod(keepAlive: true, dependencies: [gamesDao])
class CurrentGameId extends _$CurrentGameId {
  @override
  AsyncValue<int> build() {
    return const AsyncLoading();
  }

  Future<void> setGame(CurrentGameConstructor constructor) async {
    state = const AsyncLoading();
    switch (constructor) {
      case final CurrentGameConstructorExistingGame existingGame:
        state = AsyncValue.data(existingGame.gameId);
      case final CurrentGameConstructorNewGame newGame:
        state = await AsyncValue.guard(() async {
          // Create a new game with the given players
          final gameWithPlayers = GameWithPlayers(
            game: GamesCompanion.insert(
              id: const Value.absent(),
              nbPlayers: newGame.players.length,
              date: DateTime.now(),
            ),
            players: constructor.players,
          );
          final id = await ref.read(gamesDaoProvider).newGame(gameWithPlayers);
          return id;
        });
    }
  }
}

sealed class CurrentGameConstructor {}

class CurrentGameConstructorNewGame extends CurrentGameConstructor {
  final List<Player> players;

  CurrentGameConstructorNewGame(this.players);
}

class CurrentGameConstructorExistingGame extends CurrentGameConstructor {
  final int gameId;

  CurrentGameConstructorExistingGame(this.gameId);
}
