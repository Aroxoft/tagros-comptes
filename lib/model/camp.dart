enum Camp { ATTACK, DEFENSE, NONE }

String getNameCamp(Camp camp) {
  switch (camp) {
    case Camp.ATTACK:
      return "attaque";
    case Camp.DEFENSE:
      return "défense";
    case Camp.NONE:
      return "aucun";
  }
  return null;
}

const String _attack = "ATTACK";
const String _defense = "DEFENSE";

List<Camp> fromDbPetit(String petits) {
  if (petits == null || petits.isEmpty) return null;
  return (petits.split(",").map((e) {
    switch (e) {
      case _attack:
        return Camp.ATTACK;
      case _defense:
        return Camp.DEFENSE;
    }
    return null;
  })
    ..where((element) => element != null))
      .toList();
}

String toDbPetits(List<Camp> petits) {
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
    return null;
  })
    ..where((element) => element != null)).join(",");
}