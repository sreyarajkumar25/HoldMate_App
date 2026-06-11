import 'package:flutter/material.dart';
import '../theme.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double value;
  final String label;

  const CustomProgressIndicator({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.brand,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: AppTheme.brandLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brand),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}