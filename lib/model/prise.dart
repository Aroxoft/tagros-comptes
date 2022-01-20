enum Prise { petite, garde, gardeSans, gardeContre }

extension PriseExt on Prise {
  int get coeff {
    switch (this) {
      case Prise.petite:
        return 1;
      case Prise.garde:
        return 2;
      case Prise.gardeSans:
        return 4;
      case Prise.gardeContre:
        return 6;
    }
  }
  String get displayName {
    switch(this) {
      case Prise.petite:
        return "Prise";
      case Prise.garde:
        return "Garde";
      case Prise.gardeSans:
        return "Garde-sans";
      case Prise.gardeContre:
        return "Garde-contre";
    }
  }
}

const String _petite = "PETITE";
const String _garde = "GARDE";
const String _gardeSans = "GARDE-SANS";
const String _gardeContre = "GARDE-CONTRE";

Prise fromDbPrise(String prise) {
  switch (prise) {
    case _petite:
      return Prise.petite;
    case _garde:
      return Prise.garde;
    case _gardeSans:
      return Prise.gardeSans;
    case _gardeContre:
      return Prise.gardeContre;
  }
  return Prise.petite;
}

String toDbPrise(Prise prise) {
  switch (prise) {
    case Prise.petite:
      return _petite;
    case Prise.garde:
      return _garde;
    case Prise.gardeSans:
      return _gardeSans;
    case Prise.gardeContre:
      return _gardeContre;
  }
}
