import 'package:flutter/material.dart';

class TimeCard extends StatelessWidget {
  final double timeCardWidth;
  final String format;

  const TimeCard({
    super.key,
    required this.timeCardWidth,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          child: Container(
            width: timeCardWidth - 30,
            height: 20,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        Positioned(
          top: 5,
          child: Container(
            width: timeCardWidth - 20,
            height: 20,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        Positioned(
          top: 10,
          child: Container(
            width: timeCardWidth - 10,
            height: 20,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        Positioned(
          top: 15,
          child: Container(
            width: timeCardWidth,
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Text(
              format,
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
