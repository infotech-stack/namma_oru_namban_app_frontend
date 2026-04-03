import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/features/booking_details/presentation/widget/common/booking_card_decoration.dart';

class BookingScheduleCard extends StatelessWidget {
  final bool isBookNow;
  final String scheduleDate;
  final String scheduleTime;
  final Function(bool) onToggleBookNow;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;

  const BookingScheduleCard({
    super.key,
    required this.isBookNow,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.onToggleBookNow,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BookingCardDecoration(theme: theme),
      child: Column(
        children: [
          /// 🔹 BOOK NOW / SCHEDULE TOGGLE
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggleBookNow(true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isBookNow
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isBookNow
                            ? theme.colorScheme.primary
                            : theme.dividerColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: isBookNow ? AppTheme.red : theme.dividerColor,
                          size: 16.sp,
                        ),
                        Gap(6.w),
                        BText(
                          text: 'book_n',
                          fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                          fontWeight: FontWeight.w600,
                          color: isBookNow
                              ? theme.colorScheme.onSurface
                              : theme.dividerColor,
                          isLocalized: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => onToggleBookNow(false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: !isBookNow
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: !isBookNow
                            ? theme.colorScheme.primary
                            : theme.dividerColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: !isBookNow
                              ? theme.colorScheme.primary
                              : theme.dividerColor,
                          size: 16.sp,
                        ),
                        Gap(6.w),
                        BText(
                          text: 'schedule_later',
                          fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                          fontWeight: FontWeight.w600,
                          color: !isBookNow
                              ? theme.colorScheme.onSurface
                              : theme.dividerColor,
                          isLocalized: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          /// 🔥 DATE & TIME PICKER (Animated)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: child,
              ),
            ),
            child: isBookNow
                ? const SizedBox.shrink()
                : Column(
                    key: const ValueKey("schedule_section"),
                    children: [
                      Gap(14.h),

                      Row(
                        children: [
                          /// 📅 DATE PICKER
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final DateTime today = DateTime.now();
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: today,
                                  firstDate: today,
                                  lastDate: DateTime(today.year + 1, 12, 31),
                                  builder: (ctx, child) => Theme(
                                    data: Theme.of(ctx).copyWith(
                                      colorScheme: Theme.of(ctx).colorScheme,
                                    ),
                                    child: child!,
                                  ),
                                );
                                if (picked != null) {
                                  onDateSelected(picked);
                                }
                              },
                              child: _pickerBox(
                                theme,
                                value: scheduleDate,
                                icon: Icons.calendar_month_rounded,
                              ),
                            ),
                          ),

                          Gap(10.w),

                          /// ⏰ TIME PICKER
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: const TimeOfDay(
                                    hour: 14,
                                    minute: 30,
                                  ),
                                  builder: (ctx, child) => Theme(
                                    data: Theme.of(ctx).copyWith(
                                      colorScheme: Theme.of(ctx).colorScheme,
                                    ),
                                    child: child!,
                                  ),
                                );
                                if (picked != null) {
                                  onTimeSelected(picked);
                                }
                              },
                              child: _pickerBox(
                                theme,
                                value: scheduleTime,
                                icon: Icons.access_time_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// 🔹 COMMON PICKER BOX
  Widget _pickerBox(
    ThemeData theme, {
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: BText(
              text: value,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              isLocalized: false,
            ),
          ),
          Icon(icon, color: theme.colorScheme.primary, size: 18.sp),
        ],
      ),
    );
  }
}
