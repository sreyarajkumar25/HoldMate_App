import 'package:flutter/material.dart';
import 'dart:math';

class ConfettiWidget extends StatefulWidget {
  final bool isActive;
  
  const ConfettiWidget({super.key, required this.isActive});

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.isActive) {
      _controller.forward();
    }
  }
  
  @override
  void didUpdateWidget(ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward();
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!_controller.isAnimating) return const SizedBox.shrink();
        
        return Stack(
          children: List.generate(50, (index) {
            final startX = _random.nextDouble() * MediaQuery.of(context).size.width;
            final startY = -_random.nextDouble() * 100;
            final endY = MediaQuery.of(context).size.height + 100;
            final progress = _controller.value;
            final currentY = startY + (endY - startY) * progress;
            final opacity = 1.0 - progress;
            
            return Positioned(
              left: startX,
              top: currentY,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple][_random.nextInt(5)],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
