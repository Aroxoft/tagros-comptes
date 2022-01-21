import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/generated/l10n.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/prise.dart';

part 'info_entry_player.freezed.dart';

@freezed
class InfoEntryPlayerBean with _$InfoEntryPlayerBean {
  factory InfoEntryPlayerBean(
      {required PlayerBean? player,
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
      player?.name ?? '',
      infoEntry.prise.displayName,
      withPlayers?.firstOrNull?.name ?? '',
      withPlayers?.length == 2 ? (withPlayers?.lastOrNull?.name) ?? '' : '',
      infoEntry.points,
      campDesPoints,
      infoEntry.nbBouts,
    );
    // return "${infoEntry.prise.displayName} de $player${withPlayers != null && (withPlayers?.length ?? 0) > 0 ? " (avec ${withPlayers![0]}${withPlayers?.length == 2 ? " et ${withPlayers![1]}" : ""}" : ""}, ${infoEntry.points} points pour $campDesPoints, ${infoEntry.nbBouts} bout(s) pour $campDesPoints.";
  }
}
