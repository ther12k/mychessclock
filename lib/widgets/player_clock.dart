import 'package:flutter/material.dart';
import 'package:neon_widgets/neon_widgets.dart';

class PlayerClock extends StatelessWidget {
  final String playerName;
  final int time;
  final bool isActive;
  final Color backgroundColor;
  final Color textColor;
  final Color highlightColor;
  final bool isLowTime;
  final Animation<double> animation;
  final VoidCallback onTap;
  final bool isTopPlayer;

  const PlayerClock({
    Key? key,
    required this.playerName,
    required this.time,
    required this.isActive,
    required this.backgroundColor,
    required this.textColor,
    required this.highlightColor,
    required this.isLowTime,
    required this.animation,
    required this.onTap,
    required this.isTopPlayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: isActive ? highlightColor : Colors.transparent,
                width: 4,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Transform.rotate(
                    angle: isTopPlayer ? 3.14159 : 0, // Rotate 180 degrees if top player
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NeonText(
                          text: _formatMainTime(time),
                          textColor: isActive ? highlightColor : textColor,
                          blurRadius: isActive ? 20 : 0,
                          spreadColor: isActive ? highlightColor : Colors.transparent,
                          // blurStyle: BlurStyle.outer,
                          textSize: 72,
                          fontWeight: FontWeight.bold,
                          // flickerTimeInMilliSeconds: isLowTime ? 500 : 0,
                        ),
                        SizedBox(height: 8), // Add some space between main time and milliseconds
                        NeonText(
                          text: _formatMilliseconds(time),
                          textColor: isActive ? highlightColor : textColor,
                          blurRadius: isActive ? 10 : 0,
                          spreadColor: isActive ? highlightColor : Colors.transparent,
                          // blurStyle: BlurStyle.outer,
                          textSize: 36,
                          fontWeight: FontWeight.bold,
                          // flickerTimeInMilliSeconds: isLowTime ? 500 : 0,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLowTime)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red.withOpacity(animation.value),
                          width: 4,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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