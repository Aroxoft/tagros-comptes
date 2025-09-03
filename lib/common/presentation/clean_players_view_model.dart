import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/data/source/db/db_providers.dart';

class CleanPlayer extends Notifier<Stream<List<Player>>> {
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

final cleanPlayerProvider =
    NotifierProvider.autoDispose<CleanPlayer, Stream<List<Player>>>(() {
  return CleanPlayer();
    },
  dependencies: [playerDaoProvider],
);
