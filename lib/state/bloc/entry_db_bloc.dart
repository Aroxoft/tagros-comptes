import 'dart:async';

import 'package:collection/collection.dart';
import 'package:tagros_comptes/model/game/game_with_players.dart';
import 'package:tagros_comptes/model/game/info_entry_player.dart';
import 'package:tagros_comptes/model/game/player.dart';
import 'package:tagros_comptes/model/monetization/ad_or_info.dart';
import 'package:tagros_comptes/services/calculous/calculus.dart';
import 'package:tagros_comptes/services/db/games_dao.dart';
import 'package:tagros_comptes/services/monetization/ad_service.dart';

class EntriesDbBloc {
  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream we'll be using.

  // Output stream. This one will be used within our pages to display the entries.
  Stream<List<InfoEntryPlayerBean>> infoEntries;
  late Stream<Map<String, double>> sum;
  late Stream<List<AdOrInfo>> rows;

  final _addEntryController = StreamController<InfoEntryPlayerBean>.broadcast();
  final _modifyEntryController =
      StreamController<InfoEntryPlayerBean>.broadcast();

  final _deleteEntryController =
      StreamController<InfoEntryPlayerBean>.broadcast();

  // Input stream for adding new infoEntries. We'll call this from our pages
  StreamSink<InfoEntryPlayerBean> get inAddEntry => _addEntryController.sink;

  StreamSink<InfoEntryPlayerBean> get inModifyEntry =>
      _modifyEntryController.sink;

  // Input stream for deleting infoEntries. We'll call this from our pages
  StreamSink<InfoEntryPlayerBean> get inDeleteEntry =>
      _deleteEntryController.sink;

  final GameWithPlayers _game;
  final GamesDao _gamesDao;
  AdService? _adService;
  final bool _isPremium;

  EntriesDbBloc(GameWithPlayers game,
      {required GamesDao gamesDao,
      required bool isPremium,
      required Future<AdService> adService})
      : assert(game.game.id.present),
        _isPremium = isPremium,
        _gamesDao = gamesDao,
        _game = game,
        // Watch entries
        infoEntries = gamesDao
            .watchInfoEntriesInGame(game.game.id.value)
            .asBroadcastStream() {
    sum = infoEntries.map((event) => calculateSum(event,
        game.players.map((e) => PlayerBean.fromDb(e)).whereNotNull().toList()));
    adService.then((value) => _adService = value);
    rows = infoEntries.map((event) {
      final res =
          event.map((e) => AdOrInfo.info(infoEntryPlayerBean: e)).toList();

      const intervalAds = 30;
      // insert ads at regular intervals in the list
      if (!_isPremium) {
        _adService?.fetchAds(number: (event.length / intervalAds).round() + 1);
        final ads = _adService?.ads ?? [];
        var j = 0;
        for (var i = res.length - 2;
            i >= 1 && j < ads.length;
            i -= intervalAds, j++) {
          res.insert(i, AdOrInfo.ad(ad: ads[j]));
        }
      }
      return res;
    });

    // Listens for changes to the addEntryController and
    // calls _handleAddEntry on change
    _addEntryController.stream.listen(_handleAddEntry);
    _modifyEntryController.stream.listen(_handleModifyEntry);
    _deleteEntryController.stream.listen(_handleDeleteEntry);
  }

  void dispose() {
    _addEntryController.close();
    _modifyEntryController.close();
    _deleteEntryController.close();
  }

  Future<void> _handleAddEntry(InfoEntryPlayerBean entry) async {
    // Create the entry in the database
    await _gamesDao.newEntry(entry, game: _game.game);
  }

  Future<void> _handleDeleteEntry(InfoEntryPlayerBean entry) async {
    await _gamesDao.deleteEntry(entry.infoEntry.id!, game: _game.game);
  }

  Future<void> _handleModifyEntry(InfoEntryPlayerBean entry) async {
    await _gamesDao.updateEntry(entry, game: _game.game);
  }
}
