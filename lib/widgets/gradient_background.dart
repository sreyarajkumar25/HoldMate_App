import 'package:flutter/material.dart';
import '../theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool showPattern;

  const GradientBackground({
    super.key,
    required this.child,
    this.showPattern = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Stack(
        children: [
          if (showPattern) _buildPattern(),
          child,
        ],
      ),
    );
  }

  Widget _buildPattern() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.03,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 20,
          ),
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: AppTheme.brand,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}