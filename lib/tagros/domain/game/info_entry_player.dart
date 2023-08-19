import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/tagros/domain/game/info_entry.dart';
import 'package:tagros_comptes/tagros/domain/game/player.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';

part 'info_entry_player.freezed.dart';

@freezed
class InfoEntryPlayerBean with _$InfoEntryPlayerBean {
  factory InfoEntryPlayerBean({
    required PlayerBean player,
    required InfoEntryBean infoEntry,
    PlayerBean? partner1,
    PlayerBean? partner2,
  }) = _InfoEntryPlayerBean;

  InfoEntryPlayerBean._();

  @override
  String toString() {
    final String campDesPoints =
        infoEntry.pointsForAttack ? S.current.theAttack : S.current.theDefense;
    return S.current.infoEntryString(
      (partner1 != null && partner2 != null)
          ? 'twoPlayers'
          : (partner1 != null)
              ? 'onePlayer'
              : 'none',
      player.name,
      infoEntry.prise.displayName,
      partner1?.name ?? '',
      partner2?.name ?? '',
      infoEntry.points,
      campDesPoints,
      infoEntry.nbBouts,
    );
  }
}
