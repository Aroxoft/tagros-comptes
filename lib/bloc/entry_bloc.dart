import 'package:rxdart/rxdart.dart';
import 'package:tagros_comptes/bloc/bloc.dart';
import 'package:tagros_comptes/calculous/calculus.dart';
import 'package:tagros_comptes/calculous/info_entry.dart';

class EntryBloc implements Bloc {
  static final EntryBloc _bloc = EntryBloc._internal();

  BehaviorSubject<List<InfoEntry>> _entries = BehaviorSubject();
  BehaviorSubject<List<String>> _players = BehaviorSubject();

  Stream<List<InfoEntry>> get entries => _entries.stream;

  Stream<Map<String, int>> get sum =>
      entries.map((event) => calculateSum(event, _players.value));

  factory EntryBloc() {
//    if (_bloc._entries == null) {
//      _bloc._entries.value = [];
//    }
    return _bloc;
  }

  EntryBloc._internal() {
    _players.add([]);
    _entries.add([]);
  }

  setPlayers(List<String> players) {
    _players.add(players);
    _entries.add([]);
  }

  add(InfoEntry infoEntry) {
    List<InfoEntry> current = _entries.value;
    current.add(infoEntry);
    _entries.add(current);
  }

  modify(InfoEntry infoEntry) {
    List<InfoEntry> current = _entries.value;
    var i = current.indexWhere((element) => element.id == infoEntry.id);
    current[i] = infoEntry;
    _entries.add(current);
  }

  @override
  void dispose() {
    _entries.close();
    _players.close();
  }
}

EntryBloc _entryBloc;

EntryBloc entryBloc() {
  if (_entryBloc == null) {
    _entryBloc = EntryBloc();
  }
  return _entryBloc;
}
