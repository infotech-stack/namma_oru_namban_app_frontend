// lib/features/vehicle_details/presentation/widgets/common/vehicle_gradient_divider.dart

import 'package:flutter/material.dart';

class VehicleGradientDivider extends StatelessWidget {
  final Color? color;
  final double height;
  final double opacity;

  const VehicleGradientDivider({
    super.key,
    this.color,
    this.height = 1.5,
    this.opacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ?? theme.colorScheme.primary;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            dividerColor.withValues(alpha: opacity),
            dividerColor.withValues(alpha: opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
