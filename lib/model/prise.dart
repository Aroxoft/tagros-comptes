enum Prise { PETITE, GARDE, GARDE_SANS, GARDE_CONTRE }

getCoeff(Prise prise) {
  switch (prise) {
    case Prise.PETITE:
      return 1;
    case Prise.GARDE:
      return 2;
    case Prise.GARDE_SANS:
      return 4;
    case Prise.GARDE_CONTRE:
      return 6;
  }
}

getNomPrise(Prise prise) {
  switch (prise) {
    case Prise.PETITE:
      return "Prise";
    case Prise.GARDE:
      return "Garde";
    case Prise.GARDE_SANS:
      return "Garde-sans";
    case Prise.GARDE_CONTRE:
      return "Garde-contre";
  }
}

const String _petite = "PETITE",
    _garde = "GARDE",
    _garde_sans = "GARDE-SANS",
    _garde_contre = "GARDE-CONTRE";

Prise fromDbPrise(String prise) {
  switch (prise) {
    case _petite:
      return Prise.PETITE;
    case _garde:
      return Prise.GARDE;
    case _garde_sans:
      return Prise.GARDE_SANS;
    case _garde_contre:
      return Prise.GARDE_CONTRE;
  }
  return null;
}

String toDbPrise(Prise prise) {
  switch (prise) {
    case Prise.PETITE:
      return _petite;
    case Prise.GARDE:
      return _garde;
    case Prise.GARDE_SANS:
      return _garde_sans;
    case Prise.GARDE_CONTRE:
      return _garde_contre;
  }
  return null;
}
