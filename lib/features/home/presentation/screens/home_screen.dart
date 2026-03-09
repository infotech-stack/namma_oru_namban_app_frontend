import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/features/home/presentation/widgets/faveroit_heart_button_widget.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({super.key});
  final langController = Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.secondary,
        body: Column(
          children: [
            _buildTopSection(theme), // ✅ Fixed — never scrolls

            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Gap(20.h),
                        _buildChooseVehicle(theme),
                        Gap(24.h),
                        _buildTrendTitle(theme),
                        Gap(14.h),
                      ]),
                    ),
                  ),
                  // GridView sliver...
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: Obx(() {
                      final vehicles = controller.filteredVehicles;

                      if (vehicles.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Text(
                                'no_vehicles'.tr,
                                style: TextStyle(
                                  color: theme.dividerColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 14.h,
                          childAspectRatio: 1.35,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (_, index) => InkWell(
                            onTap: () {
                              controller.onvehicleDetails(vehicles[index]);
                            },
                            child: _buildVehicleCard(theme, vehicles[index]),
                          ),
                          childCount: vehicles.length,
                        ),
                      );
                    }),
                  ),
                  SliverToBoxAdapter(child: Gap(16.h)),
                  SliverToBoxAdapter(child: Gap(16.h)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── TOP SECTION ──────────────────────────────────────────────────────────

  Widget _buildTopSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(35.r),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 35.h,
        left: 16.w,
        right: 16.w,
        bottom: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(theme),
          Gap(14.h),
          Obx(
            () => Text(
              'greeting_user'.trParams({'name': controller.userName.value}),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: responsiveFont(en: 20.sp, ta: 18.sp),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Gap(4.h),
          Text(
            'next_destination'.tr,
            style: TextStyle(
              color: theme.colorScheme.secondary.withValues(alpha: 0.9),
              fontSize: 12.sp,
            ),
          ),
          Gap(16.h),
          _buildSearchBar(theme),
        ],
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.2),
          child: Icon(
            Icons.person,
            color: theme.colorScheme.secondary,
            size: 22.sp,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          height: 40.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 🌍 Language Toggle
              Obx(
                () => IconButton(
                  splashRadius: 20.r,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    langController.currentLocale.value.languageCode == 'en'
                        ? Icons.language
                        : Icons.translate,
                    color: theme.colorScheme.secondary,
                    size: 22.sp,
                  ),
                  onPressed: () => langController.toggleLanguage(),
                ),
              ),

              // ❤️ Favorites heart + badge
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: const FavHeartButton(),
              ),

              /// 🔔 Notification Icon
              IconButton(
                splashRadius: 20.r,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.notifications_outlined,
                  color: theme.colorScheme.secondary,
                  size: 22.sp,
                ),
                onPressed: () {
                  // Notification action
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: theme.colorScheme.secondary.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: theme.colorScheme.secondary,
                  size: 20.sp,
                ),
                Gap(8.w),
                Expanded(
                  child: TextField(
                    cursorColor: theme.secondaryHeaderColor,
                    controller: controller.searchController,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.secondaryHeaderColor,
                    ),
                    decoration: InputDecoration(
                      filled: false,
                      fillColor: Colors.transparent,
                      hintText: 'search'.tr,
                      hintStyle: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 13.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Gap(10.w),
        Container(
          width: 46.w,
          height: 46.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.secondary, width: 2),
          ),
          child: Icon(
            Icons.filter_alt_outlined,
            color: theme.colorScheme.secondary,
            size: 20.sp,
          ),
        ),
      ],
    );
  }

  // ── CHOOSE VEHICLE ────────────────────────────────────────────────────────

  Widget _buildChooseVehicle(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'choose_vehicle'.tr,
                style: TextStyle(
                  fontSize: responsiveFont(en: 16.sp, ta: 12.sp),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.onSeeAll,
              child: Text(
                'see_all'.tr,
                style: TextStyle(
                  fontSize: responsiveFont(en: 12.sp, ta: 10.sp),
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Gap(14.h),
        Container(
          height: 140.h,
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(20.r),
            // boxShadow: [
            //   BoxShadow(
            //     color: theme.brightness == Brightness.dark
            //         ? Colors.black.withValues(alpha: 0.35)
            //         : Colors.black.withValues(alpha: 0.06),
            //     blurRadius: 18,
            //     offset: const Offset(0, 8),
            //   ),
            // ],
          ),
          child: ClipRRect(
            // ✅ Prevents overflow outside rounded corners
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16.h,
              ), // ✅ Remove horizontal padding here
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.categories.length,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ), // ✅ Move padding here — fixes first/last item cut
                separatorBuilder: (_, __) => Gap(16.w),
                itemBuilder: (_, index) {
                  final cat = controller.categories[index];

                  return Obx(() {
                    final isSelected =
                        controller.selectedCategoryIndex.value == index;

                    return GestureDetector(
                      onTap: () => controller.selectCategory(index),
                      child: AnimatedScale(
                        scale: isSelected ? 1.05 : 1,
                        duration: const Duration(milliseconds: 200),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize:
                              MainAxisSize.min, // ✅ Prevent column expand
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  width: 64.w,
                                  height: 64.w,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.primary.withValues(
                                            alpha: 0.07,
                                          ),
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: theme.colorScheme.primary
                                                  .withValues(alpha: 0.15),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: cat.imagePath != null
                                      ? Image.asset(
                                          cat.imagePath!,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          cat.icon,
                                          size: 28.sp,
                                          color: isSelected
                                              ? theme.colorScheme.onPrimary
                                              : theme.colorScheme.primary,
                                        ),
                                ),
                              ),
                            ),
                            Gap(8.h),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: Get.textTheme.bodySmall!.copyWith(
                                fontSize: 12.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : Colors.black,
                              ),
                              child: Text(cat.labelKey.tr),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── TREND TITLE ───────────────────────────────────────────────────────────

  Widget _buildTrendTitle(ThemeData theme) {
    return Obx(() {
      final cat = controller.categories[controller.selectedCategoryIndex.value];
      final isAll = cat.filterKey == 'all';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAll ? 'top_trends'.tr : cat.labelKey.tr,
            style: TextStyle(
              fontSize: responsiveFont(en: 16.sp, ta: 12.sp),
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(4.h),
          Text(
            isAll
                ? 'most_booked'.tr
                : '${'most_booked_prefix'.tr}${cat.labelKey.tr}',
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      );
    });
  }

  // ── VEHICLE CARD ──────────────────────────────────────────────────────────

  // ════════════════════════════════════════════════════════════════
  //  _buildVehicleCard — Heart button integrated with FavoritesController
  //
  //  CHANGES from original:
  //    1. AnimatedReactButton → Custom Obx heart button
  //       (AnimatedReactButton has no isFavorite state sync support)
  //    2. FavoritesController.to.toggleFavorite(fav) on tap
  //    3. FavoritesController.to.isFavorite(id) for red/grey state
  //    4. toFavorite() helper converts VehicleModel → FavoriteVehicle
  //
  //  ADD toFavorite() to HomeController:
  //    FavoriteVehicle toFavorite(VehicleModel v) => FavoriteVehicle(
  //      id: '${v.categoryKey}_${v.nameKey}',
  //      nameKey: v.nameKey, rating: v.rating,
  //      capacity: v.capacity, fare: v.fare,
  //      eta: v.eta, categoryKey: v.categoryKey,
  //      imagePath: v.imagePath,
  //    );
  // ════════════════════════════════════════════════════════════════

  Widget _buildVehicleCard(ThemeData theme, VehicleModel vehicle) {
    // Convert VehicleModel → FavoriteVehicle once
    final fav = controller.toFavorite(vehicle);
    final favCtrl = FavoritesController.to;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: 160.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Stack(
                  children: [
                    // ── Vehicle Image ──────────────────────────
                    if (vehicle.imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          vehicle.imagePath!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    else
                      Center(
                        child: Icon(
                          Icons.fire_truck,
                          size: 40.sp,
                          color: theme.colorScheme.primary,
                        ),
                      ),

                    // ── Rating badge — Top Left ────────────────
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.greenDark,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              vehicle.rating,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── ❤️ Heart button — Top Right ───────────
                    // Obx: reacts when _favoriteMap changes
                    // isFavorite(id) → red filled / grey outlined
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Obx(() {
                        final liked = favCtrl.isFavorite(fav.id);
                        return GestureDetector(
                          onTap: () => favCtrl.toggleFavorite(fav),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: 34.r,
                            height: 34.r,
                            decoration: BoxDecoration(
                              // White bg always — red tint when liked
                              color: liked
                                  ? const Color(
                                      0xFFE53935,
                                    ).withValues(alpha: 0.12)
                                  : Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              // Filled heart = liked, outlined = not liked
                              liked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 17.sp,
                              color: liked
                                  ? const Color(0xFFE53935)
                                  : Colors.grey.shade500,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Info section (unchanged) ─────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BText(
                            text: vehicle.nameKey,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              BText(
                                text: vehicle.fare,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: theme.primaryColor,
                              ),
                              Column(
                                children: [
                                  BText(
                                    text: "km",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: theme.primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    BButton(
                      text: "book".tr,
                      onTap: () {},
                      height: 35,
                      fontSize: 14.sp,
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

  Widget _infoRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: TextStyle(fontSize: 12.sp, color: theme.dividerColor),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ────────────────────────────────────────────────────────────
}
