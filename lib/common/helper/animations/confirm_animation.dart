import 'package:flutter/material.dart';

class ConfirmationAnimation extends StatefulWidget {
  const ConfirmationAnimation({super.key});

  @override
  ConfirmationAnimationState createState() => ConfirmationAnimationState();
}

class ConfirmationAnimationState extends State<ConfirmationAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 100.0,
      ),
    );
  }
}