// lib/features/favorites/presentation/screens/favorites_screen.dart
//
// ⚠️  THEME: Theme.of(context) only — no const colors
// REUSED: Same category chip style as HomeScreen
//
// STRUCTURE (matches screenshot):
//  1. _FavAppBar        — "My Favorites" + subtitle + bell
//  2. _FavSearchBar     — Search saved vehicles + filter icon
//  3. _CategoryChips    — Same as HomeScreen (All/Car/JCB/Lorry/Bus...)
//  4. _FavList          — Favorite vehicle cards
//     └─ _FavCard       — Image + rating + name + status + Book/Remove
//  5. _EmptyState       — When no favorites in selected category

import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/features/favorites/domain/entities/favorite_entity.dart';
import 'package:userapp/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:userapp/utils/commons/app_bar/b_app_bar.dart';
import 'package:userapp/utils/commons/catch_image/app_catch_image.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: BAppBar(showLanguageToggle: true, title: 'fav_title'),
      body: Column(
        children: [
          // ── 1. AppBar (purple gradient — same as home) ────────

          // ── 2. Search bar ─────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: _FavSearchBar(theme: theme),
          ),
          Gap(14.h),

          // ── 3. Category chips (same as HomeScreen) ────────────
          _CategoryChips(theme: theme),
          Gap(8.h),

          // ── 4. Favorites list (scrollable) ────────────────────
          Expanded(child: _FavList(theme: theme)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  1. FAV APP BAR — purple gradient same as HomeScreen
//  "My Favorites" title + subtitle + bell icon
// ════════════════════════════════════════════════════════════════

// ════════════════════════════════════════════════════════════════
//  2. SEARCH BAR — "Search saved vehicles..." + filter icon
// ════════════════════════════════════════════════════════════════
class _FavSearchBar extends GetView<FavoritesController> {
  final ThemeData theme;
  const _FavSearchBar({required this.theme});

  @override
  Widget build(BuildContext context) {
    final p = theme.colorScheme.primary;

    return Row(
      children: [
        // Search field
        Expanded(
          child: Container(
            height: 46.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: p.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: controller.searchController,
              style: TextStyle(
                fontSize: responsiveFont(en: 13.sp, ta: 11.sp),
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'fav_search_hint'.tr,
                hintStyle: TextStyle(
                  color: theme.dividerColor,
                  fontSize: 13.sp,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18.sp,
                  color: theme.dividerColor,
                ),
                // Clear button
                suffixIcon: Obx(
                  () => controller.searchQuery.value.isNotEmpty
                      ? GestureDetector(
                          onTap: controller.searchController.clear,
                          child: Icon(
                            Icons.close_rounded,
                            size: 16.sp,
                            color: theme.dividerColor,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 13.h,
                ),
              ),
            ),
          ),
        ),
        Gap(10.w),

        // Filter icon button
        Container(
          width: 46.r,
          height: 46.r,
          decoration: BoxDecoration(
            color: p,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: p.withValues(alpha: 0.30),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.tune_rounded,
            size: 20.sp,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  3. CATEGORY CHIPS — same style as HomeScreen
//  Horizontal scroll, icon + label, primary highlight on selected
// ════════════════════════════════════════════════════════════════
class _CategoryChips extends GetView<FavoritesController> {
  final ThemeData theme;
  const _CategoryChips({required this.theme});

  @override
  Widget build(BuildContext context) {
    final p = theme.colorScheme.primary;

    return SizedBox(
      height: 72.h,
      child: ListView.separated(
        // ❌ Obx remove பண்ணு — outer Obx வேண்டாம்
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.categories.length,
        separatorBuilder: (_, __) => Gap(10.w),
        itemBuilder: (_, i) {
          final cat = controller.categories[i];

          // ✅ Each chip individually Obx wrap பண்ணு
          return Obx(() {
            final isActive = controller.selectedCategoryIndex.value == i;

            return GestureDetector(
              onTap: () => controller.selectCategory(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: isActive ? p : theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isActive
                            ? p
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.10,
                              ),
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: p.withValues(alpha: 0.30),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      cat['icon'] as IconData,
                      size: 20.sp,
                      color: isActive
                          ? theme.colorScheme.onPrimary
                          : theme.dividerColor,
                    ),
                  ),
                  Gap(5.h),
                  BText(
                    text: cat['labelKey'] as String,
                    fontSize: responsiveFont(en: 9.sp, ta: 8.sp),
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? p : theme.dividerColor,
                    isLocalized: true,
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  4. FAVORITES LIST
//  Obx reactive — updates when category/search changes
//  Shows _EmptyState when no favorites in selected category
// ════════════════════════════════════════════════════════════════
class _FavList extends GetView<FavoritesController> {
  final ThemeData theme;
  const _FavList({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filteredFavorites;

      // ── Empty state ─────────────────────────────────────────
      if (list.isEmpty) {
        return _EmptyState(
          theme: theme,
          isFiltered: controller.selectedCategoryIndex.value != 0,
          categoryName:
              controller.categories[controller
                      .selectedCategoryIndex
                      .value]['labelKey']
                  as String,
        );
      }

      // ── Favorites list ──────────────────────────────────────
      return RefreshIndicator(
        onRefresh: controller.refreshFavorites,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          itemCount: list.length,
          separatorBuilder: (_, __) => Gap(16.h),
          itemBuilder: (_, i) => _FavCard(theme: theme, vehicle: list[i]),
        ),
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════
//  FAV CARD — matches screenshot exactly
//  • Vehicle image (full width, rounded top)
//  • Rating badge top-left + Heart icon top-right (remove)
//  • Vehicle name + AVAILABLE/READY/BUSY status badge
//  • Fare per km
//  • Book Now + Remove buttons
// ════════════════════════════════════════════════════════════════
class _FavCard extends GetView<FavoritesController> {
  final ThemeData theme;
  final FavoriteEntity vehicle;

  const _FavCard({required this.theme, required this.vehicle});

  // Color _statusColor(String status) => switch (status) {
  //   'available' => const Color(0xFF43A047),
  //   'ready' => const Color(0xFF1E88E5),
  //   'busy' => const Color(0xFFE53935),
  //   _ => const Color(0xFF9E9E9E),
  // };

  // String _statusKey(String status) => switch (status) {
  //   'available' => 'fav_status_available',
  //   'ready' => 'fav_status_ready',
  //   'busy' => 'fav_status_busy',
  //   _ => 'fav_status_available',
  // };

  @override
  Widget build(BuildContext context) {
    final p = theme.colorScheme.primary;
    //final statusColor = _statusColor(vehicle.availabilityStatus);

    return GestureDetector(
      onTap: () => controller.onVehicleDetails(vehicle),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
              child: BCachedImage(
                imageUrl: vehicle.imagePath,
                height: 170.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            /// INFO
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.nameKey),
                  Text(vehicle.fare),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.onBookNow(vehicle),
                          child: const Text("Book"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.onRemoveFavorite(vehicle),
                          child: const Text("Remove"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  EMPTY STATE — Smart messaging:
//  • isFiltered=false (All tab) → "No favorites yet"
//  • isFiltered=true (Car/JCB..) → "No [Car] favorites yet"
//    + "Browse [Car]s" suggestion
// ════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final ThemeData theme;
  final bool isFiltered;
  final String categoryName;

  const _EmptyState({
    required this.theme,
    required this.isFiltered,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final p = theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty heart icon
            Container(
              width: 80.r,
              height: 80.r,
              decoration: BoxDecoration(
                color: p.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFiltered
                    ? Icons.search_off_rounded
                    : Icons.favorite_border_rounded,
                size: 36.sp,
                color: p.withValues(alpha: 0.50),
              ),
            ),
            Gap(20.h),

            // Title
            BText(
              text: isFiltered ? 'fav_empty_filtered_title' : 'fav_empty_title',
              fontSize: responsiveFont(en: 16.sp, ta: 14.sp),
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
              isLocalized: true,
              textAlign: TextAlign.center,
            ),
            Gap(8.h),

            // Subtitle
            BText(
              text: isFiltered
                  ? 'fav_empty_filtered_subtitle'
                  : 'fav_empty_subtitle',
              fontSize: responsiveFont(en: 13.sp, ta: 11.sp),
              color: theme.dividerColor,
              isLocalized: true,
              textAlign: TextAlign.center,
            ),
            Gap(24.h),

            // Browse vehicles button
            /*  GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: p,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: p.withValues(alpha: 0.30),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: BText(
                  text: 'fav_browse_btn',
                  fontSize: responsiveFont(en: 13.sp, ta: 11.sp),
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onPrimary,
                  isLocalized: true,
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
