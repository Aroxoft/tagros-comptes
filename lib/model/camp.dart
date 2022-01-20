import 'package:collection/collection.dart';

enum Camp { ATTACK, DEFENSE, NONE }

extension CampExt on Camp {
  String get displayName {
    switch (this) {
      case Camp.ATTACK:
        return "attaque";
      case Camp.DEFENSE:
        return "défense";
      case Camp.NONE:
        return "aucun";
    }
  }
}

const String _attack = "ATTACK";
const String _defense = "DEFENSE";

List<Camp> fromDbPetit(String? petits) {
  if (petits == null || petits.isEmpty) return [];
  return (petits.split(",").map((e) {
    switch (e) {
      case _attack:
        return Camp.ATTACK;
      case _defense:
        return Camp.DEFENSE;
    }
    return null;
  }).whereNotNull())
      .toList();
}

String? toDbPetits(List<Camp>? petits) {
  if (petits == null || petits.isEmpty) return null;
  return (petits.map((e) {
    switch (e) {
      case Camp.ATTACK:
        return _attack;
      case Camp.DEFENSE:
        return _defense;
      case Camp.NONE:
        return null;
    }
  })
        ..where((element) => element != null))
      .join(",");
}
