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