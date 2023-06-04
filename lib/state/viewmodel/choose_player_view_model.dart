import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/services/db/app_database.dart';
import 'package:tagros_comptes/services/db/players_dao.dart';
import 'package:tagros_comptes/tagros/domain/game/nb_players.dart';

class ChoosePlayerVM extends ChangeNotifier {
  ChoosePlayerVM(PlayersDao playersDao)
      : _selectedPlayers = [],
        _playersDao = playersDao;

  final PlayersDao _playersDao;
  final List<Player> _selectedPlayers;
  String? _error;

  List<Player> get selectedPlayers => UnmodifiableListView(_selectedPlayers);

  int get nbPlayers => _selectedPlayers.length;

  String? get error => _error;

  void addPlayer(Player player) {
    _selectedPlayers.add(player);
    notifyListeners();
  }

  void removePlayerAt({required int index}) {
    _selectedPlayers.removeAt(index);
    notifyListeners();
  }

  Future<void> checkForPseudoInDb(String text) async {
    final Player player = await _playersDao.addOrGetByName(name: text);
    _selectedPlayers.add(player);
    notifyListeners();
  }

  Future<List<Player>> updateSuggestions(String query) async {
    return _playersDao.searchForPlayer(query,
        notIn: _selectedPlayers.map((e) => e.id).whereNotNull().toList());
  }

  bool validatePlayers() {
    final bool correct =
        NbPlayers.values.map((e) => e.number).contains(nbPlayers);
    if (!correct) {
      _error = S.current.errorGameNbPlayers(nbPlayers);
    } else {
      _error = null;
    }
    notifyListeners();
    return correct;
  }

  void clear() {
    _selectedPlayers.clear();
    _error = null;
    notifyListeners();
  }
}
