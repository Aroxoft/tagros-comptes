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
