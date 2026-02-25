import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isLocalized;

  const BText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isLocalized = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      isLocalized ? text.tr : text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize?.sp ?? 14.sp,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
