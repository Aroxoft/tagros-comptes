import 'package:tagros_comptes/calculous/camp.dart';
import 'package:tagros_comptes/calculous/poignee.dart';
import 'package:tagros_comptes/calculous/prise.dart';

class InfoEntry {
  String player;
  List<String> withPlayers;
  Prise prise;
  bool isWon;
  int points;
  int nbBouts;

  /// are the points for the attack?
  bool pointsForAttack;
  List<Camp> petitsAuBout;
  List<PoigneeType> poignees;
}
