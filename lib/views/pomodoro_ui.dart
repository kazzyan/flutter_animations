import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class PomodoroUi extends StatefulWidget {
  const PomodoroUi({super.key});

  @override
  State<PomodoroUi> createState() => _PomodoroUiState();
}

class _PomodoroUiState extends State<PomodoroUi>
    with SingleTickerProviderStateMixin {
  bool _isRunning = false;
  final int _totalSeconds = 300;

  final double _width = 300;

  late Timer _timer;
  late ValueNotifier<int> _currentTimer;

  void _onTick(Timer timer) {
    setState(() {
      if (_currentTimer.value < _totalSeconds) {
        _currentTimer.value = _currentTimer.value + 1;
      } else {
        _stop();
      }
    });
  }

  List<String> _format(int currentSeconds) {
    var duration = Duration(seconds: currentSeconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    List<String> format = [];

    return format
      ..add(minutes)
      ..add(seconds);
  }

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(
      seconds: _totalSeconds,
    ),
  )..addListener(() {
      _progress.value = _controller.value;
    });

  final ValueNotifier<double> _progress = ValueNotifier(0.0);

  void _valueChange(double value) {
    _progress.value = 0;
    _controller.value = value;
    _currentTimer.value = (_totalSeconds * value).round();
  }

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  late final Animation<double> _arcTween = Tween(
    begin: 0.0001,
    end: 2.0,
  ).animate(_curve);

  void _play() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _onTick,
    );

    _controller.forward();

    setState(() {
      _isRunning = true;
    });
  }

  void _pause() {
    _timer.cancel();

    _controller.stop();

    setState(() {
      _isRunning = false;
    });
  }

  void _stop() {
    _pause();

    _controller.reset();

    setState(() {
      _currentTimer.value = 0;
    });
  }

  void _refresh() {
    _stop();
    _play();
  }

  @override
  void initState() {
    super.initState();

    _currentTimer = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    _currentTimer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Stack(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: PomodoroPainter(
                        progress: _arcTween.value,
                      ),
                      size: Size(_width, _width),
                    );
                  },
                ),
                Positioned(
                  top: _width / 2 - 20,
                  left: 0,
                  child: SizedBox(
                    width: _width,
                    child: ValueListenableBuilder(
                      valueListenable: _currentTimer,
                      builder: (context, value, child) {
                        return Text(
                          '${_format(value).first} : ${_format(value).last}',
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                    onPressed: _refresh,
                    icon: const Icon(Icons.refresh),
                    iconSize: 40,
                    color: Colors.black26,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.red.shade300,
                      borderRadius: BorderRadius.circular(80)),
                  child: IconButton(
                    onPressed: _isRunning ? _pause : _play,
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                    iconSize: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black12.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                    onPressed: _stop,
                    icon: const Icon(Icons.stop),
                    iconSize: 40,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ValueListenableBuilder(
              valueListenable: _progress,
              builder: (context, value, child) {
                return Slider(
                  value: value,
                  onChanged: _valueChange,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PomodoroPainter extends CustomPainter {
  final double progress;

  PomodoroPainter({
    super.repaint,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    const double strokeWidth = 20;
    final double radius = size.width / 2 * 0.8;
    const double startAngle = -0.5 * pi;

    double sweepAngle = progress * pi;

    final Paint circlePaint = Paint()
      ..color = Colors.black12.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Rect arcRect = Rect.fromCircle(
      center: center,
      radius: radius,
    );
    final Paint arcPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
      center,
      radius,
      circlePaint,
    );

    canvas.drawArc(
      arcRect,
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant PomodoroPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
