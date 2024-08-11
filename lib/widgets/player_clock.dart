import 'package:flutter/material.dart';
import '../utils/time_formatter.dart';

class PlayerClock extends StatelessWidget {
  final int time;
  final int increment;
  final bool isActive;
  final AnimationController controller;
  final Color color;

  const PlayerClock({
    required this.time,
    required this.increment,
    required this.isActive,
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          color: color.withOpacity(0.3),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatTime(time),
                  style: TextStyle(
                    fontSize: 72 + (controller.value * 20),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '+$increment',
                  style: TextStyle(
                    fontSize: 24,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
