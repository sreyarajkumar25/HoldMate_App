import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppIcons {
  static const IconData locker = Icons.lock_outline;
  static const IconData booking = Icons.receipt_long_outlined;
  static const IconData wallet = Icons.account_balance_wallet_outlined;
  static const IconData track = Icons.track_changes;
  static const IconData location = Icons.location_on;
  static const IconData star = Icons.star;
  static const IconData clock = Icons.access_time;
  static const IconData check = Icons.check_circle;
  static const IconData qr = Icons.qr_code_scanner;
}

class AnimatedLogo extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const AnimatedLogo({super.key, this.size = 80, this.onTap});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + math.sin(_controller.value * math.pi) * 0.05,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.backpack, size: 40, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}