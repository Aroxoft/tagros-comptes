import 'package:flutter/cupertino.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/model/camp.dart';
import 'package:tagros_comptes/model/poignee.dart';
import 'package:tagros_comptes/model/prise.dart';

class InfoEntryBean {
  int id;
  Prise prise;
  double points;
  int nbBouts;

  /// are the points for the attack?
  bool pointsForAttack;
  List<Camp> petitsAuBout;
  List<PoigneeType> poignees;

  InfoEntryBean(
      {@required this.points,
      @required this.nbBouts,
      this.prise = Prise.PETITE,
      this.pointsForAttack = true,
      this.petitsAuBout = const [],
      this.poignees = const [],
      this.id});

  factory InfoEntryBean.fromDb(InfoEntry infoEntry) => InfoEntryBean(
          points: infoEntry.points,
          nbBouts: infoEntry.nbBouts,
          id: infoEntry.id,
          prise: fromDbPrise(infoEntry.prise),
          pointsForAttack: infoEntry.pointsForAttack,
          petitsAuBout: [
            // TODO fix petits
          ],
          poignees: [
            // TODO fix poignees
          ]);
}
