import 'package:tagros_comptes/model/player.dart';


bool hasDuplicate(List<PlayerBean> players) =>
    players
        .map((e) => e.name)
        .toSet()
        .length != players.length;

bool hasEmpty(List<PlayerBean> players) =>
    players.any((element) => element.name == null || element.name.isEmpty);
