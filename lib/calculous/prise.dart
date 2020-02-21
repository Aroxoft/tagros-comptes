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
