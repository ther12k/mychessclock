import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/player_clock.dart';
import '../widgets/mode_selector.dart';
import '../models/time_control.dart';
import '../constants/fide_modes.dart';

class ChessClockScreen extends StatefulWidget {
  @override
  _ChessClockScreenState createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends State<ChessClockScreen>
    with TickerProviderStateMixin {
  late AnimationController _player1Controller;
  late AnimationController _player2Controller;
  late AudioPlayer _audioPlayer;
  late TimeControl _timeControl;
  bool _isPlayer1Turn = true;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _player1Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _player2Controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _audioPlayer = AudioPlayer();
    _timeControl = fideModes[0]; // Default to first mode
  }

  void _startTimer() {
    setState(() => _isRunning = true);
  }

  void _stopTimer() {
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _isPlayer1Turn = true;
      _timeControl.reset();
    });
    _player1Controller.reset();
    _player2Controller.reset();
  }

  void _switchTurn() {
    if (!_isRunning) return;
    setState(() {
      _isPlayer1Turn = !_isPlayer1Turn;
      if (_isPlayer1Turn) {
        _player2Controller.reverse();
        _player1Controller.forward();
      } else {
        _player1Controller.reverse();
        _player2Controller.forward();
      }
      _timeControl.switchTurn();
    });
    _playClickSound();
  }

  void _playClickSound() async {
    await _audioPlayer.play(AssetSource('click.mp3'));
  }

  void _setTimeControl(TimeControl newTimeControl) {
    setState(() {
      _timeControl = newTimeControl;
      _resetTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    _isRunning && !_isPlayer1Turn ? _switchTurn() : null,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: PlayerClock(
                    time: _timeControl.player2Time,
                    increment: _timeControl.increment,
                    isActive: _isRunning && !_isPlayer1Turn,
                    controller: _player2Controller,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            _buildControls(),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    _isRunning && _isPlayer1Turn ? _switchTurn() : null,
                child: PlayerClock(
                  time: _timeControl.player1Time,
                  increment: _timeControl.increment,
                  isActive: _isRunning && _isPlayer1Turn,
                  controller: _player1Controller,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isRunning ? _stopTimer : _startTimer,
                child: Text(_isRunning ? 'Pause' : 'Start'),
              ),
              ElevatedButton(
                onPressed: _resetTimer,
                child: Text('Reset'),
              ),
            ],
          ),
          SizedBox(height: 10),
          ModeSelector(
            modes: fideModes,
            currentMode: _timeControl,
            onModeChanged: _setTimeControl,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
