import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';
import 'package:tagros_comptes/services/db/app_database.dart';

part 'games_dao.g.dart';

@DriftAccessor(
    tables: [Games, InfoEntries, Players], include: {'games_queries.drift'})
class GamesDao extends DatabaseAccessor<AppDatabase> with _$GamesDaoMixin {
  GamesDao(AppDatabase db) : super(db);

  Stream<List<InfoEntryPlayerBean>> watchInfoEntriesInGame(int gameId) {
    return entriesInGame(gameId: gameId)
        .watch()
        .map((event) => event.map((row) => row.toInfoEntryPlayerBean).toList());
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

  Stream<List<GameWithPlayers>> watchAllGames() {
    // Start by watching all games
    final Stream<List<Game>> gameStream = select(games).watch();
    return gameStream.switchMap((games) {
      // This method is called whenever the list of games changes. For each
      // game, now we want to load all the players in it
      // Create a map from id to game, for performance reasons
      final idToGame = {for (var game in games) game.id: game};
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
          for (var id in ids)
            GameWithPlayers(
                game: idToGame[id]!.toCompanion(true),
                players: idToPlayers[id] ?? [])
        ];
      });
    });
  }
}

extension InfoExt on EntriesInGameResult {
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
