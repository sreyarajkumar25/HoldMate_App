import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class WhimsicalButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final double? width;
  final double? height;
  final bool isLoading;

  const WhimsicalButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.width,
    this.height,
    this.isLoading = false,
  });

  @override
  State<WhimsicalButton> createState() => _WhimsicalButtonState();
}

class _WhimsicalButtonState extends State<WhimsicalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  
  List<ConfettiParticle> _particles = [];
  Timer? _particleTimer;
  
  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _particleTimer?.cancel();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
    _generateConfetti(details.globalPosition);
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  void _generateConfetti(Offset position) {
    if (!mounted) return;
    
    final Random random = Random();
    final newParticles = <ConfettiParticle>[];
    for (int i = 0; i < 15; i++) {
      newParticles.add(ConfettiParticle(
        position: position,
        velocity: Offset(
          (random.nextDouble() - 0.5) * 800,
          -(random.nextDouble() * 500 + 200),
        ),
        color: [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
        ][random.nextInt(6)],
        size: random.nextDouble() * 8 + 4,
        life: 1.0,
      ));
    }
    
    setState(() {
      _particles = newParticles;
    });
    
    _particleTimer?.cancel();
    _particleTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _particles.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._particles.map((particle) {
          return Positioned(
            left: particle.position.dx + particle.velocity.dx * 0.2,
            top: particle.position.dy + particle.velocity.dy * 0.2,
            child: Opacity(
              opacity: particle.life,
              child: Container(
                width: particle.size,
                height: particle.size,
                decoration: BoxDecoration(
                  color: particle.color,
                  shape: particle.size > 6 ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: particle.size > 6 ? BorderRadius.circular(2) : null,
                  boxShadow: [
                    BoxShadow(
                      color: particle.color.withOpacity(0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.color != null
                    ? [widget.color!, widget.color!.withOpacity(0.7)]
                    : const [Color(0xFF6C63FF), Color(0xFF00E5FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (widget.color ?? const Color(0xFF6C63FF)).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: (widget.color ?? const Color(0xFF6C63FF)).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : widget.child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConfettiParticle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double life;

  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
    required this.life,
  });
}
