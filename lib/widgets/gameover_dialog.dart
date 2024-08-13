import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class GameOverDialog extends StatefulWidget {
  final String winner;
  final VoidCallback onNewGame;

  const GameOverDialog(
      {Key? key, required this.winner, required this.onNewGame})
      : super(key: key);

  @override
  _GameOverDialogState createState() => _GameOverDialogState();
}

class _GameOverDialogState extends State<GameOverDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Game Over',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 16),
                Text(
                  '${widget.winner} wins!',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: widget.onNewGame,
                  child: Text('New Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 100,
              minBlastForce: 80,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
