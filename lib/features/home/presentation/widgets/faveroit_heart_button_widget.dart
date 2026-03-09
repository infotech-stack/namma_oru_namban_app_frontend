// ════════════════════════════════════════════════════════════════
//  HOME SCREEN — AppBar Heart Icon + Favorites Badge
//
//  Usage — உங்க AppBar actions la add பண்ணு:
//
//  AppBar(
//    actions: [
//      _FavHeartButton(),   ← இதை add பண்ணு
//      SizedBox(width: 8.w),
//    ],
//  )
//
//  OR custom AppBar Container la:
//    Row(children: [..., _FavHeartButton()])
// ════════════════════════════════════════════════════════════════

import 'package:userapp/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';

// ════════════════════════════════════════════════════════════════
//  HEART BUTTON WIDGET — drop anywhere in AppBar
// ════════════════════════════════════════════════════════════════
class FavHeartButton extends StatelessWidget {
  const FavHeartButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = theme.colorScheme.primary;

    return Obx(() {
      final favCtrl = FavoritesController.to;
      final count = favCtrl.favoritesCount;
      final hasItems = count > 0;

      return GestureDetector(
        onTap: () {
          final homeCtrl = Get.find<HomeController>();
          if (Get.currentRoute == Routes.wrapper) {
            // Already home la இருக்கோம் — tab switch மட்டும்
            homeCtrl.currentNavIndex.value = 1;
          } else {
            // வேற screen la இருக்கோம் — navigate + tab set
            Get.toNamed(Routes.wrapper, arguments: 1);
          }
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Plain heart icon — no circle ──────────────
            Icon(
              hasItems ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 22.sp,
              color: hasItems ? Colors.white : Colors.white,
            ),

            // ── Badge — only when has favorites ───────────
            if (hasItems)
              Positioned(
                top: -5.r,
                right: -6.r,
                child: AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.elasticOut,
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 15.r,
                      minHeight: 15.r,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: p, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        count > 9 ? '9+' : '$count',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.red, // ← purple number on white badge
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
// ════════════════════════════════════════════════════════════════
//  USAGE EXAMPLES
// ════════════════════════════════════════════════════════════════

// ── Example 1: Purple gradient AppBar (onDarkBg: true) ─────────
//
// Container(
//   decoration: BoxDecoration(gradient: LinearGradient(...purple)),
//   child: Row(
//     children: [
//       // Title
//       Expanded(child: Text('Home')),
//       // Heart button — white heart on purple bg
//       const FavHeartButton(onDarkBg: true),
//       Gap(16.w),
//     ],
//   ),
// )

// ── Example 2: White AppBar (onDarkBg: false) ──────────────────
//
// AppBar(
//   actions: [
//     // Red heart on white bg
//     const FavHeartButton(onDarkBg: false),
//     SizedBox(width: 12.w),
//   ],
// )
