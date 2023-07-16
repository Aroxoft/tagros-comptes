import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tagros_comptes/state/providers.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';

part 'clean_players_view_model.g.dart';

@riverpod
class CleanPlayer extends _$CleanPlayer {
  @override
  Stream<List<Player>> build() {
    return ref.read(playerDaoProvider).unusedPlayers().watch();
  }

  Future<int> deleteAllUnused() {
    return ref.read(playerDaoProvider).deleteAllUnused();
  }

  Future<void> deletePlayer({required int? idPlayer}) {
    return ref.read(playerDaoProvider).deletePlayer(idPlayer);
  }
}
