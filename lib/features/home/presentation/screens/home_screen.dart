import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/home/presentation/controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

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
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 14.h,
                          childAspectRatio: 0.62,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (_, index) => InkWell(
                            onTap: () {
                              controller.onBookNow(vehicles[index]);
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
        bottomNavigationBar: _buildBottomNavBar(theme),
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
              'Hello, ${controller.userName.value}',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 20.sp,
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
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.secondary.withValues(alpha: 0.15),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: theme.colorScheme.secondary,
            size: 22.sp,
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
                    controller: controller.searchController,
                    style: TextStyle(fontSize: 14.sp),
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
            Text(
              'choose_vehicle'.tr,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: controller.onSeeAll,
              child: Text(
                'see_all'.tr,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Gap(14.h),
        SizedBox(
          height: 90.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.categories.length,
            separatorBuilder: (_, __) => Gap(12.w),
            itemBuilder: (_, index) {
              final cat = controller.categories[index];
              return GestureDetector(
                onTap: () => controller.selectCategory(index),
                child: Obx(() {
                  final isSelected =
                      controller.selectedCategoryIndex.value == index;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60.w,
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withValues(
                                  alpha: 0.08,
                                ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          cat.icon,
                          color: isSelected
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.primary,
                          size: 26.sp,
                        ),
                      ),
                      Gap(6.h),
                      Text(
                        cat.labelKey.tr,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.dividerColor,
                        ),
                      ),
                    ],
                  );
                }),
              );
            },
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
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
          ),
          Gap(4.h),
          Text(
            isAll
                ? 'most_booked'.tr
                : '${'most_booked_prefix'.tr}${cat.labelKey.tr}',
            style: TextStyle(fontSize: 12.sp, color: theme.dividerColor),
          ),
        ],
      );
    });
  }

  // ── VEHICLE CARD ──────────────────────────────────────────────────────────

  Widget _buildVehicleCard(ThemeData theme, VehicleModel vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
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
            child: Container(
              width: double.infinity,
              height: 110.h,
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.local_shipping,
                size: 40.sp,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vehicle.nameKey,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(Icons.star_rounded, color: Colors.amber, size: 14.sp),
                    Text(
                      vehicle.rating,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Gap(4.h),
                _infoRow(theme, 'Capacity', '${vehicle.capacity} tons'),
                _infoRow(theme, 'Fare', vehicle.fare),
                _infoRow(theme, 'ETA', '${vehicle.eta} mins'),
                Gap(8.h),
                GestureDetector(
                  onTap: () => controller.onBookNow(vehicle),
                  child: Container(
                    width: double.infinity,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Book Now',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
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
            style: TextStyle(fontSize: 10.sp, color: theme.dividerColor),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ────────────────────────────────────────────────────────────

  Widget _buildBottomNavBar(ThemeData theme) {
    final navItems = [
      {'icon': Icons.home_rounded, 'label': 'home'},
      {'icon': Icons.calendar_month_outlined, 'label': 'my_booking'},
      {'icon': Icons.person_outline_rounded, 'label': 'profile'},
    ];

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final isSelected = controller.currentNavIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.onNavTapped(index),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 6.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          navItems[index]['icon'] as IconData,
                          size: 24.sp,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.dividerColor,
                        ),
                        Gap(3.h),
                        Text(
                          (navItems[index]['label'] as String).tr,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
