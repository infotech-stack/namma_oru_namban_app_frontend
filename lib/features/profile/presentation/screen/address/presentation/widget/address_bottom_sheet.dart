// lib/features/address/presentation/widget/address_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';
import 'package:userapp/features/profile/presentation/screen/address/presentation/address_controller.dart';

import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class AddressBottomSheet extends StatelessWidget {
  final AddressEntity? editingAddress;

  const AddressBottomSheet({super.key, this.editingAddress});

  bool get isEditing => editingAddress != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<AddressController>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag handle ───────────────────────────────
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Gap(16.h),

            // ── Title ─────────────────────────────────────
            BText(
              text: isEditing ? 'edit_address' : 'add_address',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              isLocalized: true,
            ),

            Gap(20.h),

            // ── Label selector ────────────────────────────
            BText(
              text: 'address_label',
              fontSize: 12.sp,
              color: theme.dividerColor,
              isLocalized: true,
            ),
            Gap(8.h),
            Obx(
              () => Row(
                children: controller.labelOptions.map((label) {
                  final isSelected = controller.selectedLabel.value == label;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: label != 'other' ? 8.w : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => controller.selectedLabel.value = label,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10.r),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: theme.dividerColor.withValues(
                                      alpha: 0.15,
                                    ),
                                  ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                label == 'home'
                                    ? Icons.home_rounded
                                    : label == 'work'
                                    ? Icons.work_rounded
                                    : Icons.location_on_rounded,
                                size: 18.sp,
                                color: isSelected
                                    ? theme.colorScheme.secondary
                                    : theme.dividerColor,
                              ),
                              Gap(4.h),
                              Text(
                                'label_$label'.tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? theme.colorScheme.secondary
                                      : theme.dividerColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Gap(16.h),

            // ── Address text field ────────────────────────
            BText(
              text: 'address',
              fontSize: 12.sp,
              color: theme.dividerColor,
              isLocalized: true,
            ),
            Gap(8.h),
            TextField(
              controller: controller.addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'address_hint'.tr,
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: theme.dividerColor.withValues(alpha: 0.5),
                ),
                contentPadding: EdgeInsets.all(12.w),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            Gap(10.h),

            // ── Use current location button ───────────────
            Obx(
              () => GestureDetector(
                onTap: controller.isLocating.value
                    ? null
                    : controller.useCurrentLocation,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      controller.isLocating.value
                          ? SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : Icon(
                              Icons.my_location_rounded,
                              size: 16.sp,
                              color: theme.colorScheme.primary,
                            ),
                      Gap(8.w),
                      Text(
                        controller.isLocating.value
                            ? 'fetching_location'.tr
                            : 'use_current_location'.tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      // ── Location confirmed tick ────────────
                      if (controller.hasLocation.value &&
                          !controller.isLocating.value) ...[
                        Gap(8.w),
                        Icon(
                          Icons.check_circle_rounded,
                          size: 14.sp,
                          color: const Color(0xFF059669),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            Gap(16.h),

            // ── Set as default toggle ─────────────────────
            Obx(
              () => GestureDetector(
                onTap: () =>
                    controller.isDefault.value = !controller.isDefault.value,
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: controller.isDefault.value
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                          color: controller.isDefault.value
                              ? theme.colorScheme.primary
                              : theme.dividerColor.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: controller.isDefault.value
                          ? Icon(
                              Icons.check_rounded,
                              size: 13.sp,
                              color: theme.colorScheme.secondary,
                            )
                          : null,
                    ),
                    Gap(10.w),
                    Text(
                      'set_as_default_address'.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Gap(24.h),

            // ── Save button ───────────────────────────────
            Obx(
              () => BButton(
                text: isEditing ? 'update_address' : 'save_address',
                onTap: isEditing
                    ? () => controller.updateAddress(editingAddress!)
                    : controller.createAddress,
                isLoading: controller.isSaving.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
