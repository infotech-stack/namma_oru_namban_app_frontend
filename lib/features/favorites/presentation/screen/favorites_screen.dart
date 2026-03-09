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
import 'package:userapp/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:userapp/utils/commons/app_bar/b_app_bar.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
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
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        itemCount: list.length,
        separatorBuilder: (_, __) => Gap(16.h),
        itemBuilder: (_, i) => _FavCard(theme: theme, vehicle: list[i]),
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
  final FavoriteVehicle vehicle;
  const _FavCard({required this.theme, required this.vehicle});

  // Status color + label
  Color _statusColor(String status) => switch (status) {
    'available' => const Color(0xFF43A047),
    'ready' => const Color(0xFF1E88E5),
    'busy' => const Color(0xFFE53935),
    _ => const Color(0xFF9E9E9E),
  };

  String _statusKey(String status) => switch (status) {
    'available' => 'fav_status_available',
    'ready' => 'fav_status_ready',
    'busy' => 'fav_status_busy',
    _ => 'fav_status_available',
  };

  @override
  Widget build(BuildContext context) {
    final p = theme.colorScheme.primary;
    final statusColor = _statusColor(vehicle.availabilityStatus);

    return GestureDetector(
      onTap: () => controller.onVehicleDetails(vehicle),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: p.withValues(alpha: 0.07)),
          boxShadow: [
            BoxShadow(
              color: p.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image section ──────────────────────────────────
            Stack(
              children: [
                // Vehicle image
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(18.r),
                  ),
                  child: vehicle.imagePath != null
                      ? Image.asset(
                          vehicle.imagePath!,
                          height: 170.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 170.h,
                          color: p.withValues(alpha: 0.08),
                          child: Icon(
                            Icons.directions_car_rounded,
                            size: 48.sp,
                            color: p.withValues(alpha: 0.30),
                          ),
                        ),
                ),

                // Rating badge — top left
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 12.sp,
                          color: const Color(0xFFFFC107),
                        ),
                        Gap(3.w),
                        BText(
                          text: vehicle.rating,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          isLocalized: false,
                        ),
                      ],
                    ),
                  ),
                ),

                // Heart icon — top right (remove from favorites)
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: () => controller.onRemoveFavorite(vehicle),
                    child: Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 17.sp,
                        color: const Color(0xFFE53935),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Info section ───────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + status badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BText(
                          text: vehicle.nameKey,
                          fontSize: responsiveFont(en: 14.sp, ta: 14.sp),
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          isLocalized: false,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(8.w),

                      // Status pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: BText(
                          text: _statusKey(vehicle.availabilityStatus),
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                          isLocalized: true,
                        ),
                      ),
                    ],
                  ),
                  Gap(4.h),

                  // Fare
                  BText(
                    text: '${vehicle.fare}km',
                    fontSize: responsiveFont(en: 12.sp, ta: 12.sp),
                    fontWeight: FontWeight.w700,
                    color: p,
                    isLocalized: false,
                  ),
                  Gap(12.h),

                  // Gradient divider
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          p.withValues(alpha: 0.0),
                          p.withValues(alpha: 0.12),
                          p.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                  Gap(12.h),

                  // Book Now + Remove buttons
                  Row(
                    children: [
                      // Book Now — primary filled
                      Expanded(
                        child: BButton(
                          height: 35.h,
                          text: 'book',
                          fontSize: 14,
                          isLocalized: true,
                          onTap: () => controller.onBookNow(vehicle),
                        ),
                      ),
                      Gap(10.w),

                      // Remove — outlined
                      Expanded(
                        child: BButton(
                          height: 35.h,
                          fontSize: 14,
                          text: 'fav_remove_btn',
                          isLocalized: true,
                          onTap: () => controller.onRemoveFavorite(vehicle),
                          isOutline: true,
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
