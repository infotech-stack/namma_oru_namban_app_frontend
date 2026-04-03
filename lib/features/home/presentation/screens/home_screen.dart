import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/localization/language_controller.dart';
import 'package:userapp/core/resposnive/responsiveFont.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/favorites/presentation/controller/favorites_controller.dart';
import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';
import 'package:userapp/features/home/presentation/widgets/faveroit_heart_button_widget.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/catch_image/app_catch_image.dart';
import 'package:userapp/utils/commons/text/b_text.dart';
import 'package:userapp/utils/commons/shimmer/b_shimmer_container.dart';
import 'package:userapp/utils/commons/shimmer/b_shimmer_widget.dart';

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
            _buildTopSection(theme),

            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshData,
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

                    // ── Vehicle Grid ────────────────────────────────────────
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: Obx(() {
                        // ── Loading State ──
                        if (controller.isLoadingVehicles.value &&
                            controller.vehicles.isEmpty) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (_, __) => BShimmerWidget(
                                child: _buildVehicleCardShimmer(),
                              ),
                              childCount: 4,
                            ),
                          );
                        }

                        // ── Error State ──
                        if (controller.errorMessage.value.isNotEmpty &&
                            controller.vehicles.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: theme.dividerColor,
                                      size: 40.sp,
                                    ),
                                    Gap(8.h),
                                    Text(
                                      controller.errorMessage.value,
                                      style: TextStyle(
                                        color: theme.dividerColor,
                                        fontSize: 13.sp,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Gap(12.h),
                                    GestureDetector(
                                      onTap: () =>
                                          controller.fetchVehicles(reset: true),
                                      child: Text(
                                        'retry'.tr,
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        // ── Empty State ──
                        final vehicles = controller.filteredVehicles;
                        if (vehicles.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: Text(
                                  controller.searchQuery.value.isNotEmpty
                                      ? 'No results for "${controller.searchQuery.value}"'
                                      : 'no_vehicles'.tr,
                                  style: TextStyle(
                                    color: theme.dividerColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // ── Vehicle Grid ──
                        return SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 14.h,
                                childAspectRatio: 1.35,
                              ),
                          delegate: SliverChildBuilderDelegate((_, index) {
                            // ── Load More trigger ──
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (index == vehicles.length - 1 &&
                                  controller.hasMore.value) {
                                controller.loadMore();
                              }
                            });
                            return InkWell(
                              onTap: () =>
                                  controller.onVehicleCardTap(vehicles[index]),
                              child: _buildVehicleCard(theme, vehicles[index]),
                            );
                          }, childCount: vehicles.length),
                        );
                      }),
                    ),

                    // ── Load More Indicator ─────────────────────────────────
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (controller.isLoadingVehicles.value &&
                            controller.vehicles.isNotEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: BShimmerWidget(
                              child: _buildVehicleCardShimmer(),
                            ),
                          );
                        }
                        return Gap(16.h);
                      }),
                    ),
                    SliverToBoxAdapter(child: Gap(16.h)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //------HIGHLIGHT SEARCH------
  Widget highlightText(String text, String query, TextStyle style) {
    if (query.isEmpty) return Text(text, style: style);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.contains(lowerQuery)) {
      return Text(text, style: style);
    }

    final startIndex = lowerText.indexOf(lowerQuery);
    final endIndex = startIndex + lowerQuery.length;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.substring(0, startIndex), style: style),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: style.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: text.substring(endIndex), style: style),
        ],
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
          Obx(() {
            final name = controller.userName.value.trim();

            return Text(
              'greeting_user'.trParams({
                'name': name.isEmpty ? 'Guest' : name, // 🔥 fallback
              }),
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: responsiveFont(en: 20.sp, ta: 18.sp),
                fontWeight: FontWeight.w700,
              ),
            );
          }),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: const FavHeartButton(),
              ),
              IconButton(
                splashRadius: 20.r,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.notifications_outlined,
                  color: theme.colorScheme.secondary,
                  size: 22.sp,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  /*Widget _buildSearchBar(ThemeData theme) {
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

                      // 🔥 CLEAR BUTTON
                      suffixIcon: Obx(() {
                        return controller.searchQuery.value.isNotEmpty
                            ? GestureDetector(
                                onTap: controller.clearSearch,
                                child: Icon(
                                  Icons.close,
                                  size: 18.sp,
                                  color: theme.colorScheme.secondary,
                                ),
                              )
                            : const SizedBox();
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Gap(10.w),
        // Container(
        //   width: 46.w,
        //   height: 46.h,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     border: Border.all(color: theme.colorScheme.secondary, width: 2),
        //   ),
        //   child: Icon(
        //     Icons.filter_alt_outlined,
        //     color: theme.colorScheme.secondary,
        //     size: 20.sp,
        //   ),
        // ),
      ],
    );
  }*/
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
                  child: Obx(() {
                    // Hide TextField and show animated hints when empty & not focused
                    return controller.searchQuery.value.isEmpty &&
                            !controller.isSearchFocused.value
                        ? _AnimatedHintText(
                            hints: controller.searchHints,
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 13.sp,
                            ),
                            onTap: controller.focusSearch,
                          )
                        : TextField(
                            cursorColor: theme.secondaryHeaderColor,
                            controller: controller.searchController,
                            focusNode: controller.searchFocusNode,
                            autofocus: controller.isSearchFocused.value,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: theme.secondaryHeaderColor,
                            ),
                            decoration: InputDecoration(
                              filled: false,
                              fillColor: Colors.transparent,
                              hintText: controller.searchHints.first,
                              hintStyle: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontSize: 13.sp,
                              ),
                              border: InputBorder.none,
                              suffixIcon: Obx(() {
                                return controller.searchQuery.value.isNotEmpty
                                    ? GestureDetector(
                                        onTap: controller.clearSearch,
                                        child: Icon(
                                          Icons.close,
                                          size: 18.sp,
                                          color: theme.colorScheme.secondary,
                                        ),
                                      )
                                    : const SizedBox();
                              }),
                            ),
                          );
                  }),
                ),
              ],
            ),
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
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Obx(() {
              // ── Category Loading State ──
              if (controller.isLoadingCategories.value &&
                  controller.categories.isEmpty) {
                return BShimmerWidget(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 16.h,
                    ),
                    child: Row(
                      children: List.generate(
                        5,
                        (_) => Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              BShimmerContainer.rectangular(
                                width: 80,
                                height: 80,
                                borderRadius: 18,
                              ),
                              SizedBox(height: 8.h),
                              BShimmerContainer.rectangular(
                                width: 50,
                                height: 10,
                                borderRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              // ── Category Empty/Error State ──
              if (controller.categories.isEmpty) {
                return Center(
                  child: Text(
                    'no_categories'.tr,
                    style: TextStyle(
                      color: theme.dividerColor,
                      fontSize: 13.sp,
                    ),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.categories.length,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                            mainAxisSize: MainAxisSize.min,
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
                                          : theme.colorScheme.primary
                                                .withValues(alpha: 0.07),
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
                                    // ── Image: network → asset → icon fallback ──
                                    child: _buildCategoryImage(
                                      theme,
                                      cat,
                                      isSelected,
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
                                child: Text(cat.name.tr),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  /// Resolves category image via BCachedImage (handles network/asset/fallback)
  Widget _buildCategoryImage(
    ThemeData theme,
    VehicleCategoryEntity cat,
    bool isSelected,
  ) {
    if (cat.imageUrl != null && cat.imageUrl!.isNotEmpty) {
      return BCachedImage(
        imageUrl: cat.imageUrl,
        fit: BoxFit.cover,
        errorWidget: _categoryIcon(theme, cat, isSelected),
      );
    }
    return _categoryIcon(theme, cat, isSelected);
  }

  Widget _categoryIcon(
    ThemeData theme,
    VehicleCategoryEntity cat,
    bool isSelected,
  ) {
    return Icon(
      _iconForCategory(cat.filterKey),
      size: 28.sp,
      color: isSelected
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.primary,
    );
  }

  IconData _iconForCategory(String key) {
    switch (key) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'jcb':
        return Icons.construction_rounded;
      case 'lorry':
        return Icons.local_shipping_rounded;
      case 'tataace':
        return Icons.airport_shuttle_rounded;
      case 'bus':
        return Icons.directions_bus_filled_rounded;
      case 'tractor':
        return Icons.agriculture_outlined;
      case 'agri':
        return Icons.agriculture;
      default:
        return Icons.grid_view_rounded;
    }
  }

  // ── TREND TITLE ───────────────────────────────────────────────────────────

  Widget _buildTrendTitle(ThemeData theme) {
    return Obx(() {
      if (controller.categories.isEmpty) return const SizedBox.shrink();

      final index = controller.selectedCategoryIndex.value;
      final cat = index < controller.categories.length
          ? controller.categories[index]
          : null;
      final isAll = cat?.filterKey == 'all';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isAll ? 'top_trends'.tr : (cat?.name ?? '').tr,
            style: TextStyle(
              fontSize: responsiveFont(en: 14.sp, ta: 12.sp),
              fontWeight: FontWeight.w700,
            ),
          ),
          Gap(2.h),
          Text(
            isAll
                ? 'most_booked'.tr
                : '${'most_booked_prefix'.tr}${(cat?.name ?? '').tr}',
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      );
    });
  }

  // ── VEHICLE CARD ──────────────────────────────────────────────────────────

  Widget _buildVehicleCard(ThemeData theme, VehicleEntity vehicle) {
    final favEntity = controller.toFavorite(vehicle);
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
                    _buildVehicleImage(vehicle),

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
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Obx(() {
                        // final liked = favCtrl.isFavorite(fav.id);
                        final liked = favCtrl.isFavorite(favEntity.id);

                        return GestureDetector(
                          onTap: () => favCtrl.toggleFavorite(favEntity),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            width: 34.r,
                            height: 34.r,
                            decoration: BoxDecoration(
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

          // ── Info section ─────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      // ✅ VERY IMPORTANT
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
                          // highlightText(
                          //   vehicle.nameKey,
                          //   controller.searchQuery.value,
                          //   TextStyle(
                          //     fontSize: 14.sp,
                          //     fontWeight: FontWeight.w700,
                          //   ),
                          // ),
                          Row(
                            children: [
                              BText(
                                text: vehicle.fare,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: theme.primaryColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Gap(8.w), // spacing

                    Flexible(
                      child: BButton(
                        text: "book".tr,
                        onTap: () => controller.onBookNow(vehicle),
                        height: 35,
                        //width: 130.w, // 👈 slightly reduce if needed
                        fontSize: 14.sp,
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

  /// Vehicle image via BCachedImage — handles http URL, asset path, shimmer, error
  Widget _buildVehicleImage(VehicleEntity vehicle) {
    return BCachedImage(
      imageUrl: vehicle.imagePath,
      width: double.infinity,
      height: double.infinity,
      borderRadius: 16,
      fit: BoxFit.cover,
      errorWidget: _vehicleIconFallback(vehicle),
    );
  }

  /// Shimmer skeleton that mirrors the real vehicle card layout
  Widget _buildVehicleCardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BShimmerContainer.rectangular(
              width: double.infinity,
              height: 160,
              borderRadius: 16,
            ),
          ),
          // Info area
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BShimmerContainer.rectangular(
                        width: 120,
                        height: 14,
                        borderRadius: 6,
                      ),
                      SizedBox(height: 6.h),
                      BShimmerContainer.rectangular(
                        width: 70,
                        height: 12,
                        borderRadius: 6,
                      ),
                    ],
                  ),
                ),
                BShimmerContainer.rectangular(
                  width: 72,
                  height: 35,
                  borderRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleIconFallback(VehicleEntity vehicle) {
    return Center(
      child: Icon(
        _iconForCategory(vehicle.categoryKey),
        size: 40.sp,
        color: Get.theme.colorScheme.primary,
      ),
    );
  }

  /*
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
*/
}

// ── Animated cycling hint widget (slide up + fade) ───────────────────────────
// ── Animated cycling hint widget (slide up + fade) ───────────────────────────
class _AnimatedHintText extends StatefulWidget {
  final List<String> hints;
  final TextStyle style;
  final VoidCallback onTap;

  const _AnimatedHintText({
    required this.hints,
    required this.style,
    required this.onTap,
  });

  @override
  State<_AnimatedHintText> createState() => _AnimatedHintTextState();
}

class _AnimatedHintTextState extends State<_AnimatedHintText>
    with SingleTickerProviderStateMixin {
  // ✅ Nullable instead of late — safe against premature build calls
  AnimationController? _animController;
  Animation<double>? _fadeAnim;
  Animation<Offset>? _slideAnim;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController!,
      curve: Curves.easeInOut,
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1), // bottom
      end: Offset.zero, // center
    ).animate(CurvedAnimation(parent: _animController!, curve: Curves.easeOut));

    _animController!.forward();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _nextHint());
  }

  void _nextHint() {
    if (!mounted || _animController == null) return;

    _animController!.reverse().then((_) {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.hints.length;
      });
      _animController!.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Safety fallback if build fires before initState finishes
    if (_slideAnim == null || _fadeAnim == null) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Text(
          widget.hints[0],
          style: widget.style,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRect(
        child: Align(
          alignment: Alignment.centerLeft,
          child: SlideTransition(
            position: _slideAnim!,
            child: FadeTransition(
              opacity: _fadeAnim!,
              child: Text(
                widget.hints[_currentIndex],
                style: widget.style,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
