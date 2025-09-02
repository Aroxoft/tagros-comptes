import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';

part 'games_dao.g.dart';

@DriftAccessor(
    tables: [Games, InfoEntries, Players], include: {'games_queries.drift'})
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(super.db);

  Stream<List<InfoEntryPlayerBean>> watchInfoEntriesInGame(int gameId) {
    return entriesInGame(gameId: gameId)
        .watch()
        .map((event) => event.map((row) => row.toInfoEntryPlayerBean).toList());
  }

  Future<InfoEntryPlayerBean> fetchEntry(int roundId) async {
    return entryById(entryId: roundId)
        .getSingle()
        .then((value) => value.toInfoEntryPlayerBean);
  }

  Stream<List<GameWithPlayers>> watchAllGamesDrift() {
    final gameStream = allGamesWithPlayer().watch();
    return gameStream.map((event) {
      final gameWithPlayers = <int, GameWithPlayers>{};
      for (final row in event) {
        var gP = gameWithPlayers[row.gameId];
        final player = Player(pseudo: row.playerName, id: row.playerId);
        if (gP == null) {
          gP = GameWithPlayers(
              players: [player],
              game:
                  Game(id: row.gameId, nbPlayers: row.nbPlayers, date: row.date)
                      .toCompanion(true));
          gameWithPlayers[row.gameId] = gP;
        } else {
          gP.players.add(player);
        }
      }
      return gameWithPlayers.values.toList();
    });
  }

  Stream<GameWithPlayers> watchGameWithPlayers({required int gameId}) {
    final gameStream = gameWithPlayers(gameId: gameId).watch();
    return gameStream.map((event) => _mapEventToGameWithPlayers(event));
  }

  Future<GameWithPlayers> fetchGameWithPlayers({required int gameId}) {
    final game = gameWithPlayers(gameId: gameId).get();
    return game.then((event) => _mapEventToGameWithPlayers(event));
  }

  /// Map a list of rows to a game with players
  GameWithPlayers _mapEventToGameWithPlayers(List<GameWithPlayersRow> rows) {
    GameWithPlayers? game;
    for (final row in rows) {
      final player = Player(pseudo: row.playerName, id: row.playerId);
      if (game == null) {
        game = GameWithPlayers(
            players: [player],
            game: Game(id: row.gameId, nbPlayers: row.nbPlayers, date: row.date)
                .toCompanion(true));
      } else {
        game.players.add(Player(pseudo: row.playerName, id: row.playerId));
      }
    }
    return game!;
  }

  Stream<List<GameWithPlayers>> watchAllGames() {
    // Start by watching all games
    final Stream<List<Game>> gameStream = select(games).watch();
    return gameStream.switchMap((games) {
      // This method is called whenever the list of games changes. For each
      // game, now we want to load all the players in it
      // Create a map from id to game, for performance reasons
      final idToGame = {for (final game in games) game.id: game};
      final ids = idToGame.keys;

      // Select all players that are included in any game that we found
      final playerQuery = select(playerGames)
          .join([innerJoin(players, players.id.equalsExp(playerGames.player))])
        ..where(playerGames.game.isIn(ids));

      return playerQuery.watch().map((rows) {
        // Store the list of players for each game
        final idToPlayers = <int, List<Player>>{};

        // For each player (row) that is included in a game, put it in the map of players
        for (final row in rows) {
          final player = row.readTable(players);
          final id = row.readTable(playerGames).game;

          idToPlayers.putIfAbsent(id, () => []).add(player);
        }

        // Finally, merge the map of games with the map of players
        return [
          for (final id in ids)
            GameWithPlayers(
                game: idToGame[id]!.toCompanion(true),
                players: idToPlayers[id] ?? [])
        ];
      });
    });
  }

// region Insert
  Future<int> newEntry(InfoEntryPlayerBean infoEntry,
      {required int gameId}) async {
    Value<int> with1 = const Value.absent();
    Value<int> with2 = const Value.absent();
    if (infoEntry.withPlayers != null && infoEntry.withPlayers!.isNotEmpty) {
      with1 = Value(infoEntry.withPlayers![0]!.id!);
      if (infoEntry.withPlayers!.length > 1) {
        with2 = Value(infoEntry.withPlayers![1]!.id!);
      }
    }
    return transaction(() async {
      await updateGameDate(gameId: gameId);
      final id = await into(infoEntries).insert(InfoEntriesCompanion.insert(
        game: gameId,
        player: infoEntry.player.id!,
        points: infoEntry.infoEntry.points,
        prise: toDbPrise(infoEntry.infoEntry.prise),
        nbBouts: infoEntry.infoEntry.nbBouts,
        pointsForAttack: Value(infoEntry.infoEntry.pointsForAttack),
        petitAuBout: Value(toDbPetits(infoEntry.infoEntry.petitsAuBout)),
        poignee: Value(toDbPoignees(infoEntry.infoEntry.poignees)),
        with1: with1,
        with2: with2,
      ));
      return id;
    });
  }

  Future<int> newGame(GameWithPlayers gameWithPlayers) {
    return transaction(() async {
      final GamesCompanion game = gameWithPlayers.game;

      final idGame =
          await into(games).insert(game, mode: InsertMode.insertOrReplace);

      final idPlayers = await _addPlayers(gameWithPlayers.players
          .map((e) => PlayersCompanion.insert(pseudo: e.pseudo)));

      final playersToInsert = idPlayers.map(
          (e) => PlayerGamesCompanion(game: Value(idGame), player: Value(e)));
      await batch((batch) => batch.insertAll(playerGames, playersToInsert));

      return idGame;
    });
  }

  Future<List<int>> _addPlayers(Iterable<PlayersCompanion> thePlayers) async {
    final List<int> playersIds = [];
    for (final player in thePlayers) {
      final single = await (select(players)
            ..where((tbl) => players.pseudo.equals(player.pseudo.value)))
          .getSingleOrNull();
      if (single == null || single.id == null) {
        final id = await _newPlayer(playersCompanion: player);
        playersIds.add(id);
      } else {
        playersIds.add(single.id!);
      }
    }
    return playersIds;
  }

  Future<int> _newPlayer({Player? player, PlayersCompanion? playersCompanion}) {
    assert(player != null || playersCompanion != null && player == null);
    if (player != null) {
      return into(players)
          .insert(PlayersCompanion.insert(pseudo: player.pseudo));
    }
    return into(players).insert(playersCompanion!);
  }

// endregion

// region update
  Future<int> updateEntry(InfoEntryPlayerBean infoEntry,
      {required int gameId}) async {
    Value<int> with1 = const Value.absent();
    Value<int> with2 = const Value.absent();
    if (infoEntry.withPlayers != null && infoEntry.withPlayers!.isNotEmpty) {
      with1 = Value(infoEntry.withPlayers![0]!.id!);
      if (infoEntry.withPlayers!.length > 1) {
        with2 = Value(infoEntry.withPlayers![1]!.id!);
      }
    }
    return transaction(() async {
      await updateGameDate(gameId: gameId);
      return (update(infoEntries)
            ..where((tbl) => tbl.id.equalsNullable(infoEntry.infoEntry.id)))
          .write(InfoEntriesCompanion(
        player: Value(infoEntry.player.id!),
        points: Value(infoEntry.infoEntry.points),
        prise: Value(toDbPrise(infoEntry.infoEntry.prise)),
        nbBouts: Value(infoEntry.infoEntry.nbBouts),
        pointsForAttack: Value(infoEntry.infoEntry.pointsForAttack),
        petitAuBout: Value(toDbPetits(infoEntry.infoEntry.petitsAuBout)),
        poignee: Value(toDbPoignees(infoEntry.infoEntry.poignees)),
        with1: with1,
        with2: with2,
      ));
    });
  }

// endregion

// region Delete
  Future<int> deleteEntry(int entryId, {required int gameId}) async {
    return transaction(() async {
      await updateGameDate(gameId: gameId);
      return (delete(infoEntries)..where((tbl) => tbl.id.equals(entryId))).go();
    });
  }

  Future<void> deleteGame(GameWithPlayers gameWithPlayers) async {
    return transaction(() async {
      await (delete(infoEntries)
            ..where((tbl) => tbl.game.equals(gameWithPlayers.game.id.value)))
          .go();
      await (delete(playerGames)
            ..where((tbl) => tbl.game.equals(gameWithPlayers.game.id.value)))
          .go();
      await (delete(games)
            ..where((tbl) => tbl.id.equals(gameWithPlayers.game.id.value)))
          .go();
    });
  }
// endregion
}

extension InfoExt on EntryInGameResult {
  InfoEntryPlayerBean get toInfoEntryPlayerBean {
    return InfoEntryPlayerBean(
        infoEntry: InfoEntryBean(
            points: points,
            nbBouts: nbBouts,
            id: id,
            petitsAuBout: fromDbPetit(petitAuBout),
            poignees: fromDbPoignee(poignee),
            pointsForAttack: pointsForAttack,
            prise: fromDbPrise(prise)),
        player: PlayerBean(name: playerName ?? '', id: playerId),
        withPlayers: [
          if (with1Id != null && with1Name != null)
            PlayerBean(name: with1Name!, id: with1Id),
          if (with2Id != null && with2Name != null)
            PlayerBean(name: with2Name!, id: with2Id)
        ]);
  }
}
