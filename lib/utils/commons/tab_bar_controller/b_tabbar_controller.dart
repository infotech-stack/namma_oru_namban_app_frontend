import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';

class BTabController extends StatelessWidget {
  final List<String> tabs;
  final List<Widget> views;

  final List<Widget?>? prefixIcons;
  final List<Widget?>? suffixIcons;
  final TabAlignment? tabAlignment;

  final bool isScrollable;

  const BTabController({
    super.key,
    required this.tabs,
    required this.views,
    this.prefixIcons,
    this.suffixIcons,
    this.tabAlignment,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final primary = theme.colorScheme.primary;

    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: isScrollable,
            dividerColor: Colors.grey.withValues(alpha: 0.5),
            tabAlignment:
                tabAlignment ??
                (isScrollable ? TabAlignment.start : TabAlignment.fill),
            splashBorderRadius: BorderRadius.circular(8.r),

            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return primary.withValues(alpha: 0.08);
              }
              return Colors.transparent;
            }),

            /// 🔥 Only bottom underline
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: primary, width: 3.w),
            ),

            indicatorSize: TabBarIndicatorSize.label,

            labelColor: primary,
            unselectedLabelColor: Colors.grey,

            /// Selected
            labelStyle: TextStyle(
              fontSize: languageFont(en: 13.sp, ta: 11.sp),
              fontWeight: FontWeight.w700,
            ),

            /// Unselected
            unselectedLabelStyle: TextStyle(
              fontSize: languageFont(en: 12.sp, ta: 10.sp),
              fontWeight: FontWeight.w500,
            ),

            /* tabs: List.generate(tabs.length, (index) {
              return Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcons != null &&
                        prefixIcons!.length > index &&
                        prefixIcons![index] != null) ...[
                      prefixIcons![index]!,
                      SizedBox(width: 6.w),
                    ],
                    Text(tabs[index].tr),
                    if (suffixIcons != null &&
                        suffixIcons!.length > index &&
                        suffixIcons![index] != null) ...[
                      SizedBox(width: 6.w),
                      suffixIcons![index]!,
                    ],
                  ],
                ),
              );
            }),*/
            tabs: List.generate(tabs.length, (index) {
              return Builder(
                builder: (context) {
                  final tabController = DefaultTabController.of(context);

                  return AnimatedBuilder(
                    animation: tabController.animation!,
                    builder: (context, child) {
                      final isSelected = tabController.index == index;

                      final color = isSelected ? primary : Colors.grey;

                      return Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// Prefix Icon
                            if (prefixIcons != null &&
                                prefixIcons!.length > index &&
                                prefixIcons![index] != null) ...[
                              IconTheme(
                                data: IconThemeData(color: color),
                                child: DefaultTextStyle.merge(
                                  style: TextStyle(color: color),
                                  child: prefixIcons![index]!,
                                ),
                              ),
                              SizedBox(width: 6.w),
                            ],

                            /// Tab Text
                            Text(
                              tabs[index].tr,
                              style: TextStyle(
                                color: color,
                                fontSize: languageFont(en: 13.sp, ta: 11.sp),
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),

                            /// Suffix Icon
                            if (suffixIcons != null &&
                                suffixIcons!.length > index &&
                                suffixIcons![index] != null) ...[
                              SizedBox(width: 6.w),
                              IconTheme(
                                data: IconThemeData(color: color),
                                child: DefaultTextStyle.merge(
                                  style: TextStyle(color: color),
                                  child: suffixIcons![index]!,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),

          SizedBox(height: 12.h),

          Expanded(child: TabBarView(children: views)),
        ],
      ),
    );
  }
}
