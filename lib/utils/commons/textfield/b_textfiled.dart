import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool isLocalized;

  const BTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.isPassword = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    this.validator,
    this.isLocalized = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Get.theme.colorScheme.primary;

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        labelText: labelText != null
            ? (isLocalized ? labelText!.tr : labelText)
            : null,

        hintText: isLocalized ? hintText.tr : hintText,

        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),

        filled: true,
        fillColor: Colors.grey.shade100,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18.r),
          borderSide: BorderSide(color: primaryColor, width: 1.8),
        ),

        floatingLabelStyle: TextStyle(
          color: primaryColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
