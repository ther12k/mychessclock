import 'dart:ui';

import 'package:flutter/material.dart';

class AppConstants {
  static const String CLICK_SOUND = 'mixkit-handgun-click-1660.mp3';
  static const String TICK_SOUND = 'mixkit-tick-tock-clock-timer-1048.mp3';
  static const int INITIAL_TIME = 600000; // 10 minutes in milliseconds
  static const Color DARK_PLAYER_COLOR = Color(0xFF1F1F1F);
  static const Color LIGHT_PLAYER_COLOR = Color(0xFFF5E6D3);
  static const Color CONTROL_AREA_COLOR = Color(0xFFE0E0E0);

  // Updated HIGHLIGHT_COLOR for better contrast
  static const Color HIGHLIGHT_COLOR = Color(0xFFFFA500); // Bright orange

  static const List<Map<String, dynamic>> FIDE_TIME_CONTROLS = [
    {'name': 'Bullet', 'time': 60000, 'increment': 0},
    {'name': 'Blitz', 'time': 180000, 'increment': 2000},
    {'name': 'Rapid', 'time': 600000, 'increment': 5000},
    {'name': 'Classical', 'time': 5400000, 'increment': 30000},
  ];
}
