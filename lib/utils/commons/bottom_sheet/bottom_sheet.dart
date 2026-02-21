import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BBottomSheet {
  /// Show a global bottom sheet from anywhere using Get.bottomSheet
  static Future<T?> show<T>({
    required String title,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? initialChildSize,
    double? minChildSize,
    double? maxChildSize,
  }) {
    final theme = Get.theme;

    return Get.bottomSheet<T>(
      _BBottomSheetWrapper(
        title: title,
        child: child,
        initialChildSize: initialChildSize ?? 0.5,
        minChildSize: minChildSize ?? 0.3,
        maxChildSize: maxChildSize ?? 0.92,
      ),
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
    );
  }
}

class _BBottomSheetWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  const _BBottomSheetWrapper({
    required this.title,
    required this.child,
    required this.initialChildSize,
    required this.minChildSize,
    required this.maxChildSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 16.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),

              // Title Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        fontFamily: "PlayfairDisplay",
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18.sp,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(
                height: 20.h,
                thickness: 1,
                color: theme.dividerColor.withValues(alpha: 0.15),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
