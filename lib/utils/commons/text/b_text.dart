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
  final String? textAfter;

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
    this.textAfter,
  });

  @override
  Widget build(BuildContext context) {
    final fullText = textAfter != null
        ? "${isLocalized ? text.tr : text}$textAfter"
        : (isLocalized ? text.tr : text);
    return Text(
      fullText,
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
