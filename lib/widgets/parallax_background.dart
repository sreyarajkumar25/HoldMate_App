import 'package:flutter/material.dart';

class ParallaxBackground extends StatelessWidget {
  final Widget child;
  final String imageUrl;

  const ParallaxBackground({
    super.key,
    required this.child,
    this.imageUrl =
        'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=1200',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}