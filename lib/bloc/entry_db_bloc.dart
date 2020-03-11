import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/model/info_entry_player.dart';
import 'package:tagros_comptes/model/player.dart';

class EntriesDbBloc implements BlocBase {
  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream we'll be using.

  BehaviorSubject<GameWithPlayers> _game = BehaviorSubject();

  // Output stream. This one will be used within our pages to display the entries.
  Stream<List<InfoEntryPlayerBean>> infoEntries;
  Stream<Map<String, double>> sum;

  final _addEntryController = StreamController<InfoEntryPlayerBean>.broadcast();

  final _deleteEntryController =
      StreamController<InfoEntryPlayerBean>.broadcast();

  // Input stream for adding new infoEntries. We'll call this from our pages
  StreamSink<InfoEntryPlayerBean> get inAddEntry => _addEntryController.sink;

  // Input stream for deleting infoEntries. We'll call this from our pages
  StreamSink<InfoEntryPlayerBean> get inDeleteEntry =>
      _deleteEntryController.sink;

  GameWithPlayers game;

  EntriesDbBloc(GameWithPlayers game) {
    assert(game.id != null);
    this.game = game;

    // Watch entries
    infoEntries =
        MyDatabase.db.watchInfoEntriesInGame(game.id).asBroadcastStream();
    sum = infoEntries.map((event) => calculateSum(
        event, game.players.map((e) => PlayerBean.fromDb(e)).toList()));

    // Listens for changes to the addEntryController and
    // calls _handleAddEntry on change
    _addEntryController.stream.listen(_handleAddEntry);
    _deleteEntryController.stream.listen(_handleDeleteEntry);
  }

  @override
  void dispose() {
    _addEntryController.close();
    _deleteEntryController.close();
    _game.close();
//    _players.close();
  }

  void _handleAddEntry(InfoEntryPlayerBean entry) async {
    // Create the entry in the database
    await MyDatabase.db.newEntry(entry, game);
  }

  void _handleDeleteEntry(InfoEntryPlayerBean entry) async {
    await MyDatabase.db.deleteEntry(entry.infoEntry.id);
  }
}
