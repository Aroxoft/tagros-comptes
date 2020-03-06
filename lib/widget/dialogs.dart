import 'package:tagros_comptes/model/player.dart';


bool hasDuplicate(List<Player> players) =>
    players
        .map((e) => e.name)
        .toSet()
        .length != players.length;

bool hasEmpty(List<Player> players) =>
    players.any((element) => element.name == null || element.name.isEmpty);
