class TimeControl {
  final String name;
  final int initialTime;
  final int increment;
  int player1Time;
  int player2Time;

  TimeControl({
    required this.name,
    required this.initialTime,
    required this.increment,
  })  : player1Time = initialTime,
        player2Time = initialTime;

  void reset() {
    player1Time = initialTime;
    player2Time = initialTime;
  }

  void switchTurn() {
    if (player1Time > 0 && player2Time > 0) {
      if (player1Time < player2Time) {
        player1Time += increment;
      } else {
        player2Time += increment;
      }
    }
  }

  void tick() {
    if (player1Time > player2Time) {
      player1Time--;
    } else {
      player2Time--;
    }
  }
}
