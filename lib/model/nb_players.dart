enum NbPlayers { THREE, FOUR, FIVE, SEVEN, EIGHT, NINE, TEN }

getNumber(NbPlayers players) {
  switch (players) {
    case NbPlayers.THREE:
      return 3;
    case NbPlayers.FOUR:
      return 4;
    case NbPlayers.FIVE:
      return 5;
    case NbPlayers.SEVEN:
      return 7;
    case NbPlayers.EIGHT:
      return 8;
    case NbPlayers.NINE:
      return 9;
    case NbPlayers.TEN:
      return 10;
  }
}
