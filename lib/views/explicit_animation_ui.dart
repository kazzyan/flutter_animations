import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExplicitAnimationUi extends StatefulWidget {
  const ExplicitAnimationUi({super.key});

  @override
  State<ExplicitAnimationUi> createState() => _ExplicitAnimationUiState();
}

class _ExplicitAnimationUiState extends State<ExplicitAnimationUi>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<double> _progress = ValueNotifier(0.0);
  void _valueChange(double value) {
    _progress.value = 0;
    _animationController.value = value;
  }

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
    reverseDuration: const Duration(seconds: 3),
  )
    ..addListener(() {
      _progress.value = _animationController.value;
    })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });

  late final CurvedAnimation _curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.bounceInOut);

  late final Animation<Decoration> _decoration = DecorationTween(
    begin: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(0),
    ),
    end: BoxDecoration(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(200),
    ),
  ).animate(_curve);

  late final Animation<double> _rotation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_curve);

  late final Animation<double> _scale = Tween(
    begin: 1.0,
    end: 0.5,
  ).animate(_curve);

  late final Animation<Offset> _position = Tween(
    begin: Offset.zero,
    end: const Offset(0.1, -0.1),
  ).animate(_curve);

  void _play() {
    _animationController.forward();
  }

  void _pause() {
    _animationController.stop();
  }

  void _rewind() {
    _animationController.reverse();
  }

  void _repeat() {
    _animationController.repeat(reverse: true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _position,
              child: ScaleTransition(
                scale: _scale,
                child: RotationTransition(
                  turns: _rotation,
                  child: FadeTransition(
                    opacity: _rotation,
                    child: DecoratedBoxTransition(
                      decoration: _decoration,
                      child: const SizedBox(
                        width: 400,
                        height: 400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _play, child: const Text('play')),
                ElevatedButton(onPressed: _pause, child: const Text('pause')),
                ElevatedButton(onPressed: _rewind, child: const Text('rewind')),
                ElevatedButton(onPressed: _repeat, child: const Text('repeat')),
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
            )
          ],
        ),
      ),
    );
  }
}
