import 'package:flutter/material.dart';

class ImplicitAnimationUi extends StatefulWidget {
  const ImplicitAnimationUi({super.key});

  @override
  State<ImplicitAnimationUi> createState() => _ImplicitAnimationUiState();
}

class _ImplicitAnimationUiState extends State<ImplicitAnimationUi> {
  bool _visible = true;

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Implicit Animations'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInBack,
              width: size.width * 0.6,
              height: size.width * 0.6,
              transform: Matrix4.rotationZ(_visible ? 0 : 1),
              transformAlignment: Alignment.center,
              decoration: BoxDecoration(
                color: _visible ? Colors.amber : Colors.lightBlue,
                borderRadius: BorderRadius.circular(_visible ? 100 : 0),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(onPressed: _trigger, child: const Text('go'))
          ],
        ),
      ),
    );
  }
}
