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
