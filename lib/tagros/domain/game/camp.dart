import 'package:collection/collection.dart';
import 'package:tagros_comptes/generated/l10n.dart';

enum Camp { attack, defense }

extension CampExt on Camp {
  String get displayName {
    switch (this) {
      case Camp.attack:
        return S.current.campTypeAttack;
      case Camp.defense:
        return S.current.campTypeDefense;
    }
  }
}

const String _attack = "ATTACK";
const String _defense = "DEFENSE";

List<Camp> fromDbPetit(String? petits) {
  if (petits == null || petits.isEmpty) return [];
  return petits
      .split(",")
      .map((e) {
        switch (e) {
          case _attack:
            return Camp.attack;
          case _defense:
            return Camp.defense;
        }
        return null;
      })
      .whereNotNull()
      .toList();
}

String? toDbPetits(List<Camp>? petits) {
  if (petits == null || petits.isEmpty) return null;
  return petits.map((e) {
    switch (e) {
      case Camp.attack:
        return _attack;
      case Camp.defense:
        return _defense;
    }
  }).join(",");
}
