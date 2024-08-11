#!/bin/bash

# Create main directory structure
mkdir -p lib/screens lib/widgets lib/models lib/utils lib/constants

# Create main.dart
cat << EOF > lib/main.dart
import 'package:flutter/material.dart';
import 'screens/chess_clock_screen.dart';

void main() {
  runApp(ChessClockApp());
}

class ChessClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIDE Chess Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChessClockScreen(),
    );
  }
}
EOF

# Create screens/chess_clock_screen.dart
touch lib/screens/chess_clock_screen.dart

# Create widgets
touch lib/widgets/player_clock.dart
touch lib/widgets/mode_selector.dart

# Create models/time_control.dart
touch lib/models/time_control.dart

# Create utils/time_formatter.dart
cat << EOF > lib/utils/time_formatter.dart
String formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  return '\${minutes.toString().padLeft(2, '0')}:\${remainingSeconds.toString().padLeft(2, '0')}';
}
EOF

# Create constants/fide_modes.dart
cat << EOF > lib/constants/fide_modes.dart
import '../models/time_control.dart';

final List<TimeControl> fideModes = [
  TimeControl(name: 'Bullet', initialTime: 60, increment: 0),
  TimeControl(name: 'Blitz', initialTime: 180, increment: 2),
  TimeControl(name: 'Rapid', initialTime: 600, increment: 5),
  TimeControl(name: 'Classical', initialTime: 5400, increment: 30),
];
EOF

# Create pubspec.yaml with audioplayers dependency
cat << EOF > pubspec.yaml
name: chess_clock
description: A FIDE-regulated chess clock app.

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  audioplayers: ^5.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/click.mp3
EOF

# Create assets directory
mkdir -p assets

echo "Project structure created successfully!"
EOF