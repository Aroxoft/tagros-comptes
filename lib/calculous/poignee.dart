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

getNbAtouts(PoigneeType poigneeType, int nbPlayers) {
  switch (poigneeType) {
    case PoigneeType.SIMPLE:
      switch (nbPlayers) {
        case 3:
          return 12;
        case 4:
          return 10;
        case 5:
          return 8;
      }
      break;
    case PoigneeType.DOUBLE:
    // TODO: Handle this case.
      break;
    case PoigneeType.TRIPLE:
    // TODO: Handle this case.
      break;
    case PoigneeType.NONE:
    // TODO: Handle this case.
      break;
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