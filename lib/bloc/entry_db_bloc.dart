import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/data/database.dart';

class EntriesDbBloc implements BlocBase {
  // Create a broadcast controller that allows this stream to be listened
  // to multiple times. This is the primary, if not only, type of stream we'll be using.
  final _entriesController = StreamController<List<InfoEntry>>.broadcast();

  BehaviorSubject<List<String>> _players = BehaviorSubject();

  // Input stream. We add our entries to the stream using this variable
  StreamSink<List<InfoEntry>> get _inEntries => _entriesController.sink;

  // Output stream. This one will be used within our pages to display the entries.
  Stream<List<InfoEntry>> get entries => _entriesController.stream;

//  Stream<Map<String, double>> get sum =>
//      entries.map((event) => calculateSum(event, _players.value));

  // Input stream for adding new infoEntries. We'll call this from our pages
  final _addEntryController = StreamController<InfoEntry>.broadcast();

  StreamSink<InfoEntry> get inAddEntry => _addEntryController.sink;

  EntriesDbBloc() {
    // Retrieve all the entries on initialization
    getEntries();
    _players.add(["A", "B", "C", "D"]);
    // Listens for changes to the addEntryController and
    // calls _handleAddEntry on change
    _addEntryController.stream.listen(_handleAddEntry);
  }

  @override
  void dispose() {
    _entriesController.close();
    _addEntryController.close();
    _players.close();
  }

  void _handleAddEntry(InfoEntry entry) async {
    // Create the entry in the database
    await DBProvider.db.newEntry(entry);

    // Retrieve all the entries again after one is added
    // This allows our pages to update properly and display the
    // newly added entry.
    getEntries();
  }

  void getEntries() async {
    // Retrieve all the entries from the database
    List<InfoEntry> entries = await DBProvider.db.getInfoEntries();

    // Add all of the entries to the stream so we can grab them later from our pages
    _inEntries.add(entries);
  }

  setPlayers(List<String> players) {
    _players.add(players);
  }
}
