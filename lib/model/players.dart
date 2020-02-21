enum Players { THREE, FOUR, FIVE, SEVEN, EIGHT, NINE, TEN }

getNumber(Players players) {
  switch (players) {
    case Players.THREE:
      return 3;
    case Players.FOUR:
      return 4;
    case Players.FIVE:
      return 5;
    case Players.SEVEN:
      return 7;
    case Players.EIGHT:
      return 8;
    case Players.NINE:
      return 9;
    case Players.TEN:
      return 10;
  }
}
