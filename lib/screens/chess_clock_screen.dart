import 'package:chess_clock/config/constant.dart';
import 'package:chess_clock/widgets/controler_area.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import '../widgets/player_clock.dart';

class ChessClockScreen extends StatefulWidget {
  @override
  _ChessClockScreenState createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends State<ChessClockScreen>
    with TickerProviderStateMixin {
  late Stopwatch _stopwatch;
  int _lastElapsedTime = 0;
  String _player1Name = 'White';
  String _player2Name = 'Black';
  late int _player1Time;
  late int _player2Time;
  int _player1Moves = 0;
  int _player2Moves = 0;
  int _increment = 0;
  bool _isPlayer1Turn = true;
  bool _isRunning = false;
  Timer? _timer;
  late AudioPlayer _audioPlayer;
  late AudioPlayer _tickPlayer;
  late AnimationController _player1AnimationController;
  late AnimationController _player2AnimationController;

  @override
  void initState() {
    super.initState();
    _player1Time = AppConstants.INITIAL_TIME;
    _player2Time = AppConstants.INITIAL_TIME;
    _audioPlayer = AudioPlayer();
    _tickPlayer = AudioPlayer();
    _player1AnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _player2AnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _stopwatch = Stopwatch();
    _loadAudio();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSettingsDialog());
  }

  void _loadAudio() async {
    await _audioPlayer.setSource(AssetSource(AppConstants.CLICK_SOUND));
    await _tickPlayer.setSource(AssetSource(AppConstants.TICK_SOUND));
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        int elapsedTime = _stopwatch.elapsedMilliseconds;
        int deltaTime = elapsedTime - _lastElapsedTime;
        _lastElapsedTime = elapsedTime;

        if (_isPlayer1Turn) {
          _player1Time -= deltaTime;
          if (_player1Time <= 10000 && _player1Time > 0) {
            _playTickSound();
          }
        } else {
          _player2Time -= deltaTime;
          if (_player2Time <= 10000 && _player2Time > 0) {
            _playTickSound();
          }
        }
        if (_player1Time <= 0 || _player2Time <= 0) {
          _stopTimer();
          _showGameOverDialog();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _stopwatch.stop();
    _stopwatch.reset();
    _lastElapsedTime = 0;
    _tickPlayer.stop();
  }

  void _playTickSound() {
    if (_tickPlayer.state != PlayerState.playing) {
      _tickPlayer.resume();
    }
  }

  void _switchTurn() {
    if (!_isRunning) return;
    setState(() {
      _isPlayer1Turn = !_isPlayer1Turn;
      if (_isPlayer1Turn) {
        _player2Time += _increment;
        _player2Moves++;
      } else {
        _player1Time += _increment;
        _player1Moves++;
      }
    });
    _audioPlayer.resume();
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Settings'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'White Player Name'),
                  onChanged: (value) => _player1Name = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Black Player Name'),
                  onChanged: (value) => _player2Name = value,
                ),
                SizedBox(height: 20),
                ...AppConstants.FIDE_TIME_CONTROLS
                    .map(
                      (control) => ElevatedButton(
                        child: Text(control['name']),
                        onPressed: () {
                          setState(() {
                            _player1Time = control['time'];
                            _player2Time = control['time'];
                            _increment = control['increment'];
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                    .toList(),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Custom Time'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showCustomTimeDialog();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCustomTimeDialog() {
    int minutes = 10;
    int seconds = 0;
    int incrementSeconds = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Custom Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Minutes'),
                keyboardType: TextInputType.number,
                onChanged: (value) => minutes = int.tryParse(value) ?? 10,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Seconds'),
                keyboardType: TextInputType.number,
                onChanged: (value) => seconds = int.tryParse(value) ?? 0,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Increment (seconds)'),
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    incrementSeconds = int.tryParse(value) ?? 0,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                _showSettingsDialog();
              },
            ),
            TextButton(
              child: Text('Set'),
              onPressed: () {
                setState(() {
                  _player1Time = (minutes * 60 + seconds) * 1000;
                  _player2Time = _player1Time;
                  _increment = incrementSeconds * 1000;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showGameOverDialog() {
    String winner = _player1Time <= 0 ? _player2Name : _player1Name;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('$winner wins!'),
          actions: <Widget>[
            TextButton(
              child: Text('New Game'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
                _showSettingsDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _player1Time = AppConstants.INITIAL_TIME;
      _player2Time = AppConstants.INITIAL_TIME;
      _player1Moves = 0;
      _player2Moves = 0;
      _isPlayer1Turn = true;
      _isRunning = false;
    });
    _stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PlayerClock(
              playerName: _player2Name,
              time: _player2Time,
              isActive: _isRunning && !_isPlayer1Turn,
              textColor: AppConstants.LIGHT_PLAYER_COLOR,
              backgroundColor: AppConstants.DARK_PLAYER_COLOR,
              highlightColor: AppConstants.HIGHLIGHT_COLOR,
              isLowTime: _player2Time <= 10000,
              animation: _player2AnimationController,
              onTap: () => _isRunning && !_isPlayer1Turn ? _switchTurn() : null,
              isTopPlayer: true,
            ),
          ),
          ControlArea(
            isRunning: _isRunning,
            player1Moves: _player1Moves,
            player2Moves: _player2Moves,
            onToggleTimer: _toggleTimer,
            onOpenSettings: () {
              _stopTimer();
              _showSettingsDialog();
            },
          ),
          Expanded(
            child: PlayerClock(
              playerName: _player1Name,
              time: _player1Time,
              isActive: _isRunning && _isPlayer1Turn,
              textColor: AppConstants.DARK_PLAYER_COLOR,
              backgroundColor: AppConstants.LIGHT_PLAYER_COLOR,
              highlightColor: AppConstants.HIGHLIGHT_COLOR,
              isLowTime: _player1Time <= 10000,
              animation: _player1AnimationController,
              onTap: () => _isRunning && _isPlayer1Turn ? _switchTurn() : null,
              isTopPlayer: false,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _tickPlayer.dispose();
    _player1AnimationController.dispose();
    _player2AnimationController.dispose();
    super.dispose();
  }
}
