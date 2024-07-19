import 'dart:math';

import 'package:flutter/material.dart';

class AppleWatchUi extends StatefulWidget {
  const AppleWatchUi({super.key});

  @override
  State<AppleWatchUi> createState() => _AppleWatchUiState();
}

class _AppleWatchUiState extends State<AppleWatchUi>
    with SingleTickerProviderStateMixin {
  late double _innerRandom;
  late double _middleRandom;
  late double _outerRandom;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(
      seconds: 1,
    ),
  )..forward();

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  late Animation<double> _innerProgress = Tween(
    begin: 0.001,
    end: _innerRandom,
  ).animate(_curve);

  late Animation<double> _middleProgress = Tween(
    begin: 0.001,
    end: _middleRandom,
  ).animate(_curve);

  late Animation<double> _outerProgress = Tween(
    begin: 0.001,
    end: _outerRandom,
  ).animate(_curve);

  void _replay() {
    final innerNewBegin = _innerProgress.value;
    final middleNewBegin = _middleProgress.value;
    final outerNewBegin = _outerProgress.value;

    _setRandom();

    setState(() {
      _innerProgress = Tween(
        begin: innerNewBegin,
        end: _innerRandom,
      ).animate(_curve);
      _middleProgress = Tween(
        begin: middleNewBegin,
        end: _middleRandom,
      ).animate(_curve);
      _outerProgress = Tween(
        begin: outerNewBegin,
        end: _outerRandom,
      ).animate(_curve);
    });

    _controller.forward(from: 0);
  }

  void _setRandom() {
    setState(() {
      _innerRandom = Random().nextDouble() * 2.0;
      _middleRandom = Random().nextDouble() * 2.0;
      _outerRandom = Random().nextDouble() * 2.0;
    });
  }

  @override
  void initState() {
    super.initState();

    _setRandom();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Apple Watch'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: AppleWatchPainter(
                innerProgress: _innerProgress.value,
                middleProgress: _middleProgress.value,
                outerProgress: _outerProgress.value,
              ),
              size: const Size(500, 500),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _replay,
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}

class AppleWatchPainter extends CustomPainter {
  final double innerProgress;
  final double middleProgress;
  final double outerProgress;

  AppleWatchPainter({
    super.repaint,
    required this.innerProgress,
    required this.middleProgress,
    required this.outerProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    const double strokeWidth = 35;
    final double innerRadius = size.width / 2 * 0.5;
    final double middleRadius = size.width / 2 * 0.65;
    final double outerRadius = size.width / 2 * 0.8;
    const double startAngle = -0.5 * pi;

    double innerSweepAngle = innerProgress * pi;
    double middleSweepAngle = middleProgress * pi;
    double outerSweepAngle = outerProgress * pi;

    final Paint innerCirclePaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final Paint middleCirclePaint = Paint()
      ..color = Colors.green.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final Paint outerCirclePaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Rect innerArcRect = Rect.fromCircle(
      center: center,
      radius: innerRadius,
    );
    final Paint innerArcPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Rect middleArcRect = Rect.fromCircle(
      center: center,
      radius: middleRadius,
    );
    final Paint middleArcPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Rect outerArcRect = Rect.fromCircle(
      center: center,
      radius: outerRadius,
    );
    final Paint outerArcPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
      center,
      innerRadius,
      innerCirclePaint,
    );
    canvas.drawCircle(
      center,
      middleRadius,
      middleCirclePaint,
    );
    canvas.drawCircle(
      center,
      outerRadius,
      outerCirclePaint,
    );

    canvas.drawArc(
        innerArcRect, startAngle, innerSweepAngle, false, innerArcPaint);
    canvas.drawArc(
        middleArcRect, startAngle, middleSweepAngle, false, middleArcPaint);
    canvas.drawArc(
        outerArcRect, startAngle, outerSweepAngle, false, outerArcPaint);
  }

  @override
  bool shouldRepaint(covariant AppleWatchPainter oldDelegate) {
    return oldDelegate.innerProgress != innerProgress ||
        oldDelegate.middleProgress != middleProgress ||
        oldDelegate.outerProgress != outerProgress;
  }
}
