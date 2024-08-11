import 'package:flutter/material.dart';
import '../models/game_settings.dart';

class SettingsPopup extends StatefulWidget {
  final GameSettings initialSettings;
  final Function(GameSettings) onStart;
  final Function onCancel;

  SettingsPopup({
    required this.initialSettings,
    required this.onStart,
    required this.onCancel,
  });

  @override
  _SettingsPopupState createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  late String _selectedMode;
  late int _customMinutes;
  late int _customIncrement;
  late String _player1Name;
  late String _player2Name;
  late String _selectedSound;

  final List<String> _soundOptions = ['Classic', 'Digital', 'Wood'];

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.initialSettings.mode;
    _customMinutes = widget.initialSettings.initialTime ~/ 60;
    _customIncrement = widget.initialSettings.increment;
    _player1Name = widget.initialSettings.player1Name;
    _player2Name = widget.initialSettings.player2Name;
    _selectedSound = widget.initialSettings.soundEffect;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Game Settings'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: _selectedMode,
              items: ['Bullet', 'Blitz', 'Rapid', 'Classical', 'Custom']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMode = newValue!;
                });
              },
            ),
            if (_selectedMode == 'Custom') ...[
              TextField(
                decoration: InputDecoration(labelText: 'Minutes per player'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _customMinutes = int.tryParse(value) ?? 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Increment (seconds)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _customIncrement = int.tryParse(value) ?? 0,
              ),
            ],
            TextField(
              decoration: InputDecoration(labelText: 'White Player Name'),
              onChanged: (value) => _player1Name = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Black Player Name'),
              onChanged: (value) => _player2Name = value,
            ),
            DropdownButton<String>(
              value: _selectedSound,
              items: _soundOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSound = newValue!;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => widget.onCancel(),
        ),
        TextButton(
          child: Text('Start'),
          onPressed: () {
            GameSettings newSettings = GameSettings(
              mode: _selectedMode,
              initialTime: _selectedMode == 'Custom'
                  ? _customMinutes * 60
                  : _getInitialTime(_selectedMode),
              increment: _selectedMode == 'Custom'
                  ? _customIncrement
                  : _getIncrement(_selectedMode),
              player1Name: _player1Name,
              player2Name: _player2Name,
              soundEffect: _selectedSound,
            );
            widget.onStart(newSettings);
          },
        ),
      ],
    );
  }

  int _getInitialTime(String mode) {
    switch (mode) {
      case 'Bullet':
        return 60;
      case 'Blitz':
        return 180;
      case 'Rapid':
        return 600;
      case 'Classical':
        return 5400;
      default:
        return 600;
    }
  }

  int _getIncrement(String mode) {
    switch (mode) {
      case 'Bullet':
        return 0;
      case 'Blitz':
        return 2;
      case 'Rapid':
        return 5;
      case 'Classical':
        return 30;
      default:
        return 5;
    }
  }
}

