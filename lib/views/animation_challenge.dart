import 'package:flutter/material.dart';

class AnimationChallenge extends StatefulWidget {
  const AnimationChallenge({super.key});

  @override
  State<AnimationChallenge> createState() => _AnimationChallengeState();
}

class _AnimationChallengeState extends State<AnimationChallenge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );

  late final List<Animation<double>> _fadeAnimations = List.generate(
    25,
    (index) {
      final int row = index ~/ 5;
      final int col = index % 5;
      final int adjustedIndex = row.isEven ? col : 4 - col;
      final double beginInterval = adjustedIndex * 0.04;
      final double endInterval = beginInterval + 0.3;

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            beginInterval,
            endInterval,
            curve: Curves.easeInOut,
          ),
        ),
      );
    },
  );

  late final List<Animation<Decoration>> _decorationAnimations = List.generate(
    25,
    (index) {
      final int row = index ~/ 5;
      final int col = index % 5;
      final int adjustedIndex = row.isEven ? col : 4 - col;
      final double beginInterval = adjustedIndex * 0.04;
      final double endInterval = beginInterval + 0.3;

      return DecorationTween(
        begin: const BoxDecoration(color: Colors.orange),
        end: const BoxDecoration(color: Colors.black),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            beginInterval,
            endInterval,
            curve: Curves.easeInOut,
          ),
        ),
      );
    },
  );

  void _playAnimations() {
    for (var i = 0; i < 25; i++) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void initState() {
    super.initState();

    _playAnimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment 29'),
      ),
      body: Center(
        child: GridView(
          padding: const EdgeInsets.all(30),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 40,
            mainAxisSpacing: 40,
          ),
          children: List.generate(25, (index) {
            return FadeTransition(
              opacity: _fadeAnimations[index],
              child: DecoratedBoxTransition(
                decoration: _decorationAnimations[index],
                child: const SizedBox(
                  width: 50,
                  height: 50,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
