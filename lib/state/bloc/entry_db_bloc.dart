import 'dart:async';

import 'package:collection/collection.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/services/db/app_database.dart';

class EntriesDbBloc {
  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream we'll be using.

  // Output stream. This one will be used within our pages to display the entries.
  Stream<List<InfoEntryPlayerBean>> infoEntries;
  late Stream<Map<String, double>> sum;

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
  final MyDatabase _database;

  EntriesDbBloc(GameWithPlayers game, {required MyDatabase database})
      : assert(game.game.id != null),
        _database = database,
        _game = game,
        // Watch entries
        infoEntries =
            database.watchInfoEntriesInGame(game.game.id!).asBroadcastStream() {
    sum = infoEntries.map((event) => calculateSum(event,
        game.players.map((e) => PlayerBean.fromDb(e)).whereNotNull().toList()));

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
    await _database.newEntry(entry, _game);
  }

  Future<void> _handleDeleteEntry(InfoEntryPlayerBean entry) async {
    await _database.deleteEntry(entry.infoEntry.id!);
  }

  Future<void> _handleModifyEntry(InfoEntryPlayerBean entry) async {
    await _database.updateEntry(entry);
  }
}
