import 'package:chess_clock/config/constant.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class GameClockScreen extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final int initialTime;
  final int increment;

  GameClockScreen({
    required this.player1Name,
    required this.player2Name,
    required this.initialTime,
    required this.increment,
  });

  @override
  _GameClockScreenState createState() => _GameClockScreenState();
}

class _GameClockScreenState extends State<GameClockScreen> {
  late int _player1Time;
  late int _player2Time;
  bool _isPlayer1Turn = true;
  bool _isRunning = false;
  Timer? _timer;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _player1Time = widget.initialTime;
    _player2Time = widget.initialTime;
    _audioPlayer = AudioPlayer();
    _loadAudio();
  }

  void _loadAudio() async {
    await _audioPlayer.setSource(AssetSource(AppConstants.CLICK_SOUND));
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
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        if (_isPlayer1Turn) {
          _player1Time -= 10;
        } else {
          _player2Time -= 10;
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
  }

  void _switchTurn() {
    if (!_isRunning) return;
    setState(() {
      _isPlayer1Turn = !_isPlayer1Turn;
      if (_isPlayer1Turn) {
        _player2Time += widget.increment;
      } else {
        _player1Time += widget.increment;
      }
    });
    _audioPlayer.resume();
  }

  void _showGameOverDialog() {
    String winner = _player1Time <= 0 ? widget.player2Name : widget.player1Name;
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
                Navigator.of(context).pop(); // Return to the settings screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _isRunning && !_isPlayer1Turn ? _switchTurn() : null,
              child: Container(
                color: AppConstants.DARK_PLAYER_COLOR,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.player2Name,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        _formatTime(_player2Time),
                        style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            color: AppConstants.CONTROL_AREA_COLOR,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  onPressed: _toggleTimer,
                  iconSize: 36,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _isRunning && _isPlayer1Turn ? _switchTurn() : null,
              child: Container(
                color: AppConstants.LIGHT_PLAYER_COLOR,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.player1Name,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        _formatTime(_player1Time),
                        style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).floor() % 100;
    int seconds = (milliseconds / 1000).floor() % 60;
    int minutes = (milliseconds / 60000).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${hundreds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
