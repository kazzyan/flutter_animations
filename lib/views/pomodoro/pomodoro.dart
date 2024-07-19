import 'dart:async';
import 'package:animations/views/pomodoro/set_button.dart';
import 'package:animations/views/pomodoro/time_card.dart';
import 'package:animations/views/pomodoro/view_count.dart';
import 'package:flutter/material.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({super.key});

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  double _timeCardWidth = 0;

  bool _isRunning = false;
  int _totalSeconds = 1200;

  late Timer _timer;

  int _idle = 3000;
  bool _isIdle = false;

  int _countRound = 0;
  int _countGoal = 0;

  int _isSelected = 20;

  final List<int> _sets = [
    15,
    20,
    25,
    30,
    35,
  ];

  void _setCardWidth(double width) {
    setState(() {
      _timeCardWidth = width;
    });
  }

  void _setTimer(int set) {
    setState(() {
      _totalSeconds = set * 60;
    });
  }

  void _idling(Timer timer) {
    if (_idle == 0) {
      setState(() {
        _isIdle = false;
        _idle == 3000;
      });
    } else {
      setState(() {
        _idle = _idle - 1;
      });
    }
  }

  void _setIdle() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _idling,
    );
    setState(() {
      _isIdle = true;
    });
  }

  void _onSelectTap(int set) {
    if (_isRunning) {
      _onPausePressed();
    }

    _setTimer(set);
    setState(() {
      _isSelected = set;
    });
  }

  void _onTick(Timer timer) {
    if (_totalSeconds == 0) {
      _onPausePressed();
      _setTimer(_isSelected);
      _setIdle();
      if (_countRound == 4) {
        setState(() {
          _countGoal = _countGoal + 1;
          _countRound = 0;
        });
      } else {
        setState(() {
          _countRound = _countRound + 1;
        });
      }
    } else {
      setState(() {
        _totalSeconds = _totalSeconds - 1;
      });
    }
  }

  void _onPlayPressed() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _onTick,
    );
    setState(() {
      _isRunning = true;
    });
  }

  void _onPausePressed() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  List<String> _format(int totalSeconds) {
    var duration = Duration(seconds: totalSeconds);

    List<String> format = [];
    return format
      ..add(duration.toString().split('.').first.substring(2, 4))
      ..add(duration.toString().split('.').first.substring(5, 7));
  }

  @override
  Widget build(BuildContext context) {
    _setCardWidth(MediaQuery.of(context).size.width / 3);
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              child: const Text(
                'POMOTIMER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TimeCard(
                        timeCardWidth: _timeCardWidth,
                        format: _format(_totalSeconds).first,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: const Text(
                              ':',
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white38),
                            ),
                          ),
                        ],
                      ),
                      TimeCard(
                        timeCardWidth: _timeCardWidth,
                        format: _format(_totalSeconds).last,
                      ),
                    ],
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.lightGreen,
                          Colors.lightGreen.withOpacity(0),
                          Colors.lightGreen.withOpacity(0),
                          Colors.lightGreen,
                        ],
                        stops: const [
                          0.0,
                          0.4,
                          0.6,
                          1.0,
                        ],
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 50,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: _timeCardWidth,
                              ),
                              for (var set in _sets) ...[
                                SetButton(
                                    onTap: () => _onSelectTap(set),
                                    isSelected: _isSelected == set,
                                    title: '$set'),
                                set == _sets.last
                                    ? const SizedBox()
                                    : const SizedBox(
                                        width: 20,
                                      ),
                              ],
                              SizedBox(
                                width: _timeCardWidth,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _isRunning
                        ? _onPausePressed
                        : _countGoal == 12 || _isIdle
                            ? null
                            : _onPlayPressed,
                    icon: Icon(
                      _isRunning
                          ? Icons.pause
                          : _isIdle
                              ? Icons.square
                              : Icons.play_arrow,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ViewCount(
                  count: _countRound,
                  title: 'round',
                ),
                ViewCount(
                  count: _countGoal,
                  title: 'goal',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
