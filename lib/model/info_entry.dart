import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';
import 'package:tagros_comptes/services/db/app_database.dart';

part 'info_entry.freezed.dart';

@freezed
class InfoEntryBean with _$InfoEntryBean {
  factory InfoEntryBean(
      {required double points,
      required int nbBouts,
      @Default(Prise.PETITE) Prise prise,

      /// are the points for the attack?
      @Default(true) bool pointsForAttack,
      @Default(const []) List<Camp> petitsAuBout,
      @Default(const []) List<PoigneeType> poignees,
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
