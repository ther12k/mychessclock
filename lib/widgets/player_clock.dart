// lib/widgets/player_clock.dart
import 'package:flutter/material.dart';

class PlayerClock extends StatelessWidget {
  final String playerName;
  final int time;
  final bool isActive;
  final Color backgroundColor;
  final Color textColor;
  final bool isLowTime;
  final Animation<double> animation;
  final VoidCallback onTap;

  const PlayerClock({
    Key? key,
    required this.playerName,
    required this.time,
    required this.isActive,
    required this.backgroundColor,
    required this.textColor,
    required this.isLowTime,
    required this.animation,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                color: backgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        playerName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isActive ? textColor : textColor.withOpacity(0.5),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            _formatMainTime(time),
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: isActive ? textColor : textColor.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            _formatMilliseconds(time),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: isActive ? textColor : textColor.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isLowTime)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red.withOpacity(animation.value),
                            width: 8,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red.withOpacity(animation.value),
                            size: 100,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _formatMainTime(int milliseconds) {
    int seconds = (milliseconds / 1000).floor() % 60;
    int minutes = (milliseconds / 60000).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatMilliseconds(int milliseconds) {
    int hundreds = (milliseconds / 10).floor() % 100;
    return '.${hundreds.toString().padLeft(2, '0')}';
  }
}