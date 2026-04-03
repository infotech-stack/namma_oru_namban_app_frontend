import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BShimmerWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const BShimmerWidget({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Shimmer.fromColors(
            // ✅ FIX: Proper shimmer colors
            baseColor: baseColor ?? Colors.grey.shade200,
            highlightColor: highlightColor ?? Colors.grey.shade100,
            period: duration,
            child: child,
          )
        : child;
  }
}
