enum PoigneeType { SIMPLE, DOUBLE, TRIPLE, NONE }

getPoigneePoints(PoigneeType poigneeType) {
  switch (poigneeType) {
    case PoigneeType.SIMPLE:
      return 20;
    case PoigneeType.DOUBLE:
      return 30;
    case PoigneeType.TRIPLE:
      return 40;
    case PoigneeType.NONE:
      return 0;
  }
}

int getNbAtouts(PoigneeType poigneeType, int nbPlayers) {
  switch (poigneeType) {
    case PoigneeType.SIMPLE:
      switch (nbPlayers) {
        case 3:
          return 13;
        case 4:
          return 10;
        case 5:
          return 8;
        case 7:
          return 11;
        case 8:
          return 9;
        case 9:
          return 7;
        case 10:
          return 7;
      }
      break;
    case PoigneeType.DOUBLE:
      switch (nbPlayers) {
        case 3:
          return 15;
        case 4:
          return 13;
        case 5:
          return 10;
        case 7:
          return 13;
        case 8:
          return 11;
        case 9:
          return 9;
        case 10:
          return 9;
      }
      break;
    case PoigneeType.TRIPLE:
      switch (nbPlayers) {
        case 3:
          return 18;
        case 4:
          return 15;
        case 5:
          return 13;
        case 7:
          return 15;
        case 8:
          return 13;
        case 9:
          return 12;
        case 10:
          return 11;
      }
      break;
    case PoigneeType.NONE:
      return 0;
  }
  return 0;
}

getNamePoignee(PoigneeType poigneeType) {
  switch (poigneeType) {
    case PoigneeType.SIMPLE:
      return "simple";
    case PoigneeType.DOUBLE:
      return "double";
    case PoigneeType.TRIPLE:
      return "triple";
    case PoigneeType.NONE:
      return "pas de poignée";
  }
}