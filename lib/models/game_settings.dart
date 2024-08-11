class GameSettings {
  final String mode;
  final int initialTime;
  final int increment;
  final String player1Name;
  final String player2Name;
  final String soundEffect;

  GameSettings({
    required this.mode,
    required this.initialTime,
    required this.increment,
    required this.player1Name,
    required this.player2Name,
    required this.soundEffect,
  });
}
