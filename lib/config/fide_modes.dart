import '../models/time_control.dart';

final List<TimeControl> fideModes = [
  TimeControl(name: 'Bullet', initialTime: 60, increment: 0),
  TimeControl(name: 'Blitz', initialTime: 180, increment: 2),
  TimeControl(name: 'Rapid', initialTime: 600, increment: 5),
  TimeControl(name: 'Classical', initialTime: 5400, increment: 30),
];