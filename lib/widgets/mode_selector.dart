import 'package:flutter/material.dart';
import '../models/time_control.dart';

class ModeSelector extends StatelessWidget {
  final List<TimeControl> modes;
  final TimeControl currentMode;
  final Function(TimeControl) onModeChanged;

  const ModeSelector({
    required this.modes,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TimeControl>(
      value: currentMode,
      items: modes.map((TimeControl mode) {
        return DropdownMenuItem<TimeControl>(
          value: mode,
          child: Text(mode.name),
        );
      }).toList(),
      onChanged: (TimeControl? newValue) {
        if (newValue != null) {
          onModeChanged(newValue);
        }
      },
    );
  }
}
