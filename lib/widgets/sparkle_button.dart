import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SparkleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final Color? color;
  
  const SparkleButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.color,
  });

  @override
  State<SparkleButton> createState() => _SparkleButtonState();
}

class _SparkleButtonState extends State<SparkleButton> with SingleTickerProviderStateMixin {
  late AnimationController _sparkleController;
  late List<Sparkle> _sparkles;

  @override
  void initState() {
    super.initState();
    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _sparkles = List.generate(8, (index) => Sparkle());
    _sparkleController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    super.dispose();
  }

  void _onTap() {
    _sparkleController.reset();
    _sparkleController.forward();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.color != null
                ? [widget.color!, widget.color!.withOpacity(0.6)]
                : const [Color(0xFF6C63FF), Color(0xFF00E5FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (widget.color ?? const Color(0xFF6C63FF)).withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ..._sparkles.map((sparkle) {
              final progress = _sparkleController.value;
              final index = _sparkles.indexOf(sparkle);
              final delay = index * 0.1;
              final isActive = progress > delay;
              final normalizedProgress = isActive ? (progress - delay) / (1 - delay) : 0;
              final opacityValue = normalizedProgress < 0.5 ? normalizedProgress * 2 : (1 - normalizedProgress) * 2;
              final opacity = opacityValue.toDouble();
              
              if (!isActive) return const SizedBox.shrink();
              
              final angle = sparkle.angle + normalizedProgress * 4;
              final distance = 40 + normalizedProgress * 60;
              final dx = distance * cos(angle);
              final dy = distance * sin(angle);
              
              return Positioned(
                left: 0,
                top: 0,
                child: Transform.translate(
                  offset: Offset(dx + 20, dy + 20),
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: sparkle.size,
                      height: sparkle.size,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(opacity),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(opacity * 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Sparkle {
  final double angle;
  final double size;
  
  Sparkle() : 
    angle = Random().nextDouble() * 2 * pi,
    size = 3 + Random().nextDouble() * 4;
}
