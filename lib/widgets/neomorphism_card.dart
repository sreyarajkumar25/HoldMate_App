import 'package:flutter/material.dart';

class NeomorphismCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const NeomorphismCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(-5, -5),
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}