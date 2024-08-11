// lib/widgets/control_area.dart
import 'package:flutter/material.dart';

class ControlArea extends StatelessWidget {
  final bool isRunning;
  final int player1Moves;
  final int player2Moves;
  final VoidCallback onToggleTimer;
  final VoidCallback onOpenSettings;

  const ControlArea({
    Key? key,
    required this.isRunning,
    required this.player1Moves,
    required this.player2Moves,
    required this.onToggleTimer,
    required this.onOpenSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey[300],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('White', style: TextStyle(fontSize: 12)),
              Text('Moves: $player1Moves',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          IconButton(
            icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
            onPressed: onToggleTimer,
            iconSize: 36,
            color: Colors.black,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: onOpenSettings,
            iconSize: 36,
            color: Colors.black,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Black', style: TextStyle(fontSize: 12)),
              Text('Moves: $player2Moves',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
