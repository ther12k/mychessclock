import 'package:flutter/material.dart';
import '../models/game_settings.dart';

class GameModeSelector extends StatefulWidget {
  final Function(GameSettings) onSettingsSelected;

  const GameModeSelector({Key? key, required this.onSettingsSelected}) : super(key: key);

  @override
  _GameModeSelectorState createState() => _GameModeSelectorState();
}

class _GameModeSelectorState extends State<GameModeSelector> {
  String _selectedMode = 'Rapid';
  String _whitePlayerName = '';
  String _blackPlayerName = '';
  int _customMinutes = 10;
  int _customIncrement = 0;

  final List<String> _gameModes = ['Bullet', 'Blitz', 'Rapid', 'Classical', 'Custom Time'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Game Settings',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          _buildPlayerNameInput(
            hintText: 'White Player Name',
            onChanged: (value) => setState(() => _whitePlayerName = value),
          ),
          SizedBox(height: 8),
          _buildPlayerNameInput(
            hintText: 'Black Player Name',
            onChanged: (value) => setState(() => _blackPlayerName = value),
          ),
          SizedBox(height: 16),
          ..._gameModes.map((mode) => _buildModeButton(mode)),
          if (_selectedMode == 'Custom Time') ...[
            SizedBox(height: 8),
            _buildCustomTimeInputs(),
          ],
        ],
      ),
    );
  }

  Widget _buildPlayerNameInput({required String hintText, required Function(String) onChanged}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildModeButton(String mode) {
    bool isSelected = _selectedMode == mode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton(
        child: Text(mode),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: isSelected ? Colors.blue : Colors.grey[700],
          padding: EdgeInsets.symmetric(vertical: 12),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => setState(() => _selectedMode = mode),
      ),
    );
  }

  Widget _buildCustomTimeInputs() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Minutes',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() => _customMinutes = int.tryParse(value) ?? 10),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Increment',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() => _customIncrement = int.tryParse(value) ?? 0),
          ),
        ),
      ],
    );
  }

  // Helper methods for time settings (unchanged)
  int _getInitialTime(String mode) {
    switch (mode) {
      case 'Bullet': return 60;
      case 'Blitz': return 180;
      case 'Rapid': return 600;
      case 'Classical': return 5400;
      case 'Custom Time': return _customMinutes * 60;
      default: return 600;
    }
  }

  int _getIncrement(String mode) {
    switch (mode) {
      case 'Bullet': return 0;
      case 'Blitz': return 2;
      case 'Rapid': return 5;
      case 'Classical': return 30;
      case 'Custom Time': return _customIncrement;
      default: return 5;
    }
  }
}