enum NbPlayers { three, four, five, seven, eight, nine, ten }

extension NbPlayerExt on NbPlayers {
  int get number {
    switch (this) {
      case NbPlayers.three:
        return 3;
      case NbPlayers.four:
        return 4;
      case NbPlayers.five:
        return 5;
      case NbPlayers.seven:
        return 7;
      case NbPlayers.eight:
        return 8;
      case NbPlayers.nine:
        return 9;
      case NbPlayers.ten:
        return 10;
    }
  }
}
