import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/model/info_entry.dart';
import 'package:tagros_comptes/model/player.dart';
import 'package:tagros_comptes/model/prise.dart';

part 'info_entry_player.freezed.dart';

@freezed
class InfoEntryPlayerBean with _$InfoEntryPlayerBean {
  InfoEntryPlayerBean._();

  factory InfoEntryPlayerBean(
      {required PlayerBean? player,
      required InfoEntryBean infoEntry,
      List<PlayerBean?>? withPlayers}) = _InfoEntryPlayerBean;

  @override
  String toString() {
    String campDesPoints =
        infoEntry.pointsForAttack ? "l'attaque" : "la défense";
    return "${infoEntry.prise.displayName} de $player${withPlayers != null && (withPlayers?.length ?? 0) > 0 ? " (avec ${withPlayers![0]}${withPlayers?.length == 2 ? " et ${withPlayers![1]}" : ""}" : ""}, ${infoEntry.points} points pour $campDesPoints, ${infoEntry.nbBouts} bout(s) pour $campDesPoints.";
  }
}
