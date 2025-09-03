import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/tagros/data/source/db/app_database.dart';
import 'package:tagros_comptes/tagros/domain/game/camp.dart';
import 'package:tagros_comptes/tagros/domain/game/poignee.dart';
import 'package:tagros_comptes/tagros/domain/game/prise.dart';

part 'info_entry.freezed.dart';

@freezed
sealed class InfoEntryBean with _$InfoEntryBean {
  factory InfoEntryBean(
      {required double points,
      required int nbBouts,
      @Default(Prise.petite) Prise prise,

      /// are the points for the attack?
      @Default(true) bool pointsForAttack,
      @Default(<Camp>[]) List<Camp> petitsAuBout,
      @Default(<PoigneeType>[]) List<PoigneeType> poignees,
      int? id}) = _InfoEntryBean;

  factory InfoEntryBean.fromDb(InfoEntry infoEntry) => InfoEntryBean(
      points: infoEntry.points,
      nbBouts: infoEntry.nbBouts,
      id: infoEntry.id,
      prise: fromDbPrise(infoEntry.prise),
      pointsForAttack: infoEntry.pointsForAttack,
      petitsAuBout: fromDbPetit(infoEntry.petitAuBout),
      poignees: fromDbPoignee(infoEntry.poignee));
}
