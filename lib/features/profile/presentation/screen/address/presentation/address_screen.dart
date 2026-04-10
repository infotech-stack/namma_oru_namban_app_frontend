// lib/features/address/presentation/screen/address_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';
import 'package:userapp/features/profile/presentation/screen/address/presentation/address_controller.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class AddressScreen extends GetView<AddressController> {
  const AddressScreen({super.key});

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
            _buildAppBar(context, theme),
            Expanded(child: _buildBody(theme)),
          ],
        ),
        floatingActionButton: Obx(() {
          if (controller.addresses.length >= 5) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: controller.openAddSheet,
            backgroundColor: theme.colorScheme.primary,
            icon: Icon(Icons.add, color: theme.colorScheme.secondary),
            label: Text(
              'add_address'.tr,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return Container(
      color: theme.colorScheme.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 16.w,
        right: 16.w,
        bottom: 14.h,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: theme.colorScheme.secondary,
              size: 20.sp,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: BText(
              text: 'saved_addresses',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.secondary,
              isLocalized: true,
            ),
          ),
          // Address count badge
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${controller.addresses.length}/5',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────
  Widget _buildBody(ThemeData theme) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmer(theme);
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return _buildError(theme);
      }

      if (controller.addresses.isEmpty) {
        return _buildEmpty(theme);
      }

      return RefreshIndicator(
        onRefresh: controller.fetchAddresses,
        color: theme.colorScheme.primary,
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
          itemCount: controller.addresses.length,
          separatorBuilder: (_, __) => Gap(12.h),
          itemBuilder: (_, i) => _AddressCard(
            address: controller.addresses[i],
            theme: theme,
            onEdit: () => controller.openEditSheet(controller.addresses[i]),
            onDelete: () =>
                controller.showDeleteDialog(controller.addresses[i]),
            onSetDefault: () => controller.setDefault(controller.addresses[i]),
          ),
        ),
      );
    });
  }

  // ── Shimmer ───────────────────────────────────────────────────
  Widget _buildShimmer(ThemeData theme) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      separatorBuilder: (_, __) => Gap(12.h),
      itemBuilder: (_, __) => Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }

  // ── Empty ─────────────────────────────────────────────────────
  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off_outlined,
              size: 38.sp,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),
          Gap(16.h),
          BText(
            text: 'no_addresses',
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            isLocalized: true,
          ),
          Gap(6.h),
          BText(
            text: 'no_addresses_sub',
            fontSize: 12.sp,
            color: theme.dividerColor,
            isLocalized: true,
          ),
          Gap(24.h),
          ElevatedButton.icon(
            onPressed: controller.openAddSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
            icon: Icon(
              Icons.add_location_alt_rounded,
              color: theme.colorScheme.secondary,
              size: 18.sp,
            ),
            label: Text(
              'add_first_address'.tr,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────
  Widget _buildError(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: theme.dividerColor,
          ),
          Gap(12.h),
          Text(
            controller.errorMessage.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: theme.dividerColor),
          ),
          Gap(16.h),
          ElevatedButton(
            onPressed: controller.fetchAddresses,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'retry'.tr,
              style: TextStyle(color: theme.colorScheme.secondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Address Card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  final AddressEntity address;
  final ThemeData theme;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.theme,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  IconData get _labelIcon {
    switch (address.label.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'work':
        return Icons.work_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  Color get _labelColor {
    switch (address.label.toLowerCase()) {
      case 'home':
        return const Color(0xFF2563EB);
      case 'work':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF059669);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(16.r),
        border: address.isDefault
            ? Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // ── Label icon ────────────────────────────
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: _labelColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(_labelIcon, color: _labelColor, size: 20.sp),
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.displayLabel.tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          if (address.isDefault) ...[
                            Gap(6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'default'.tr,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Gap(2.h),
                      Text(
                        address.address,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.dividerColor,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // ── Actions menu ──────────────────────────
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: theme.dividerColor,
                    size: 20.sp,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit();
                      case 'delete':
                        onDelete();
                      case 'setDefault':
                        onSetDefault();
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded, size: 16.sp),
                          Gap(8.w),
                          Text('edit'.tr),
                        ],
                      ),
                    ),
                    if (!address.isDefault)
                      PopupMenuItem(
                        value: 'setDefault',
                        child: Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 16.sp,
                              color: theme.colorScheme.primary,
                            ),
                            Gap(8.w),
                            Text('set_default'.tr),
                          ],
                        ),
                      ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            size: 16.sp,
                            color: const Color(0xFFEF4444),
                          ),
                          Gap(8.w),
                          Text(
                            'delete'.tr,
                            style: const TextStyle(color: Color(0xFFEF4444)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
