import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final ShapeBorder? shape;
  final Color? color;

  const BShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape,
    this.color,
  });

  const BShimmerContainer.circular({
    super.key,
    required double size,
    this.color,
  }) : width = size,
       height = size,
       borderRadius = size / 2,
       shape = null;

  const BShimmerContainer.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
    this.color,
  }) : shape = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.w,
      height: height?.h,
      decoration: ShapeDecoration(
        // ✅ FIX: Light grey instead of dark disabledColor
        color: color ?? Colors.grey.shade200,
        shape:
            shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
      ),
    );
  }
}
