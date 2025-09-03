import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';

part 'info_entry_player.freezed.dart';

@freezed
sealed class InfoEntryPlayerBean with _$InfoEntryPlayerBean {
  factory InfoEntryPlayerBean(
      {required PlayerBean player,
      required InfoEntryBean infoEntry,
      List<PlayerBean?>? withPlayers}) = _InfoEntryPlayerBean;

  InfoEntryPlayerBean._();

  @override
  String toString() {
    final String campDesPoints =
        infoEntry.pointsForAttack ? S.current.theAttack : S.current.theDefense;
    return S.current.infoEntryString(
      withPlayers?.length == 2
          ? 'twoPlayers'
          : withPlayers?.length == 1
              ? 'onePlayer'
              : 'none',
      player.name,
      infoEntry.prise.displayName,
      withPlayers?.firstOrNull?.name ?? '',
      withPlayers?.length == 2 ? withPlayers?.lastOrNull?.name ?? '' : '',
      infoEntry.points,
      campDesPoints,
      infoEntry.nbBouts,
    );
  }
}
