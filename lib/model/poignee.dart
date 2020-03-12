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
      return "non";
  }
}

const String _simple = "SIMPLE";
const String _double = "DOUBLE";
const String _triple = "TRIPLE";
const String _none = "NONE";

String toDbPoignees(List<PoigneeType> poignees) => poignees == null
    ? null
    : (poignees.map((e) {
        switch (e) {
          case PoigneeType.SIMPLE:
            return _simple;
          case PoigneeType.DOUBLE:
            return _double;
          case PoigneeType.TRIPLE:
            return _triple;
          case PoigneeType.NONE:
            return null;
        }
        return null;
      })
          ..where((element) => element != null))
        .join(",");

List<PoigneeType> fromDbPoignee(String poignees) {
  if (poignees == null || poignees.isEmpty) return null;
  return (poignees.split(",").map((e) {
    switch (e) {
      case _simple:
        return PoigneeType.SIMPLE;
      case _double:
        return PoigneeType.DOUBLE;
      case _triple:
        return PoigneeType.TRIPLE;
      case _none:
        return null;
    }
    return null;
  })
        ..where((element) => element != null))
      .toList();
}
