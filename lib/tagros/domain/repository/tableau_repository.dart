import 'package:tagros_comptes/tagros/domain/game/game_with_players.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry_player.dart';

abstract class TableauRepository {
  Stream<GameWithPlayers> get watchPlayers;

  Stream<List<InfoEntryPlayerBean>> get watchInfoEntries;

  Stream<Map<String, double>> get watchSums;

  Future<void> addEntry(InfoEntryPlayerBean entry);

  Future<void> modifyEntry(InfoEntryPlayerBean entry);

  Future<void> deleteEntry(int entryId);
}
