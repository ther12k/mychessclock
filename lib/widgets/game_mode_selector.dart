import 'package:flutter/material.dart';
import '../models/game_settings.dart';

class GameModeSelector extends StatefulWidget {
  final Function(GameSettings) onSettingsSelected;

  GameModeSelector({required this.onSettingsSelected});

  @override
  _GameModeSelectorState createState() => _GameModeSelectorState();
}

class _GameModeSelectorState extends State<GameModeSelector> {
  String _selectedMode = 'Rapid';
  int _customMinutes = 10;
  int _customIncrement = 5;
  String _player1Name = 'Player 1';
  String _player2Name = 'Player 2';
  String _selectedSound = 'Classic';

  final List<String> _soundOptions = ['Classic', 'Digital', 'Wood'];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Chess Clock Pro', style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 24),
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
        SizedBox(height: 16),
        if (_selectedMode == 'Custom') ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Minutes:'),
              SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      _customMinutes = int.tryParse(value) ?? 10,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Increment:'),
              SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      _customIncrement = int.tryParse(value) ?? 5,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(labelText: 'Player 1 Name'),
          onChanged: (value) => _player1Name = value,
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(labelText: 'Player 2 Name'),
          onChanged: (value) => _player2Name = value,
        ),
        SizedBox(height: 16),
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
        SizedBox(height: 24),
        ElevatedButton(
          child: Text('Start Game'),
          onPressed: () {
            GameSettings settings = GameSettings(
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
            widget.onSettingsSelected(settings);
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
