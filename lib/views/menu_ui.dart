import 'package:animations/views/animation_challenge.dart';
import 'package:animations/views/apple_watch_ui.dart';
import 'package:animations/views/assignment29_ui.dart';
import 'package:animations/views/explicit_animation_ui.dart';
import 'package:animations/views/implicit_animation_ui.dart';
import 'package:animations/views/pomodoro/pomodoro.dart';
import 'package:animations/views/pomodoro_ui.dart';
import 'package:flutter/material.dart';

class MenuUi extends StatelessWidget {
  const MenuUi({super.key});

  void _goToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter Animation Masterclass',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ImplicitAnimationUi(),
                );
              },
              child: const Text(
                'Implicit Animations',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const ExplicitAnimationUi(),
                );
              },
              child: const Text(
                'Explicit Animations',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const Assignment29Ui(),
                );
              },
              child: const Text(
                'Assignment 29',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const AnimationChallenge(),
                );
              },
              child: const Text(
                'Assignment Challenge',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const AppleWatchUi(),
                );
              },
              child: const Text(
                'Apple Watch',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const PomodoroUi(),
                );
              },
              child: const Text(
                'Pomodoro Animation',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(
                  context,
                  const Pomodoro(),
                );
              },
              child: const Text(
                'Pomodoro Timer',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
