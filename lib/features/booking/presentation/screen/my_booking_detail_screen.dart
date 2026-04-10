// lib/features/booking/presentation/screen/my_booking_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_detail_entity.dart';
import 'package:userapp/features/booking/presentation/controller/my_booking_detail_controller.dart';
import 'package:userapp/features/booking/presentation/widget/my_booking_detail_shimmer.dart';
import 'package:userapp/features/review/driver_review/data/datasources/review_datasource.dart';
import 'package:userapp/features/review/driver_review/data/repositories/review_repository_impl.dart';
import 'package:userapp/features/review/driver_review/domain/usecases/add_review_usecase.dart';
import 'package:userapp/features/review/driver_review/presentation/review_controller.dart';
import 'package:userapp/utils/commons/button/b_button.dart';
import 'package:userapp/utils/commons/text/b_text.dart';

class MyBookingDetailScreen extends StatefulWidget {
  const MyBookingDetailScreen({super.key});

  @override
  State<MyBookingDetailScreen> createState() => _MyBookingDetailScreenState();
}

class _MyBookingDetailScreenState extends State<MyBookingDetailScreen> {
  late final MyBookingDetailController controller;
  bool _isReviewControllerRegistered = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    controller = Get.find<MyBookingDetailController>();

    // Fetch data if not already loaded
    if (controller.bookingDetail.value == null && !controller.isLoading.value) {
      controller.fetchDetail();
    }

    _registerReviewControllerWhenReady();
  }

  void _registerReviewControllerWhenReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRegisterReviewController();
    });
  }

  void _checkAndRegisterReviewController() {
    final detail = controller.bookingDetail.value;
    if (detail != null && !_isReviewControllerRegistered) {
      final tag = 'review_${detail.id}';
      if (!Get.isRegistered<ReviewController>(tag: tag)) {
        Get.put(ReviewController(), tag: tag);
        _isReviewControllerRegistered = true;
        print('✅ ReviewController registered for booking: ${detail.id}');
      }
    } else if (controller.isLoading.value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _checkAndRegisterReviewController();
        }
      });
    }
  }

  @override
  void dispose() {
    if (_isReviewControllerRegistered) {
      final detail = controller.bookingDetail.value;
      if (detail != null) {
        final tag = 'review_${detail.id}';
        if (Get.isRegistered<ReviewController>(tag: tag)) {
          Get.delete<ReviewController>(tag: tag);
        }
      }
    }
    super.dispose();
  }

  // ── Pull to Refresh Method ────────────────────────────────────────────
  Future<void> _onRefresh() async {
    await controller.refreshDetail();
  }

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
            Expanded(
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _onRefresh,
                color: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.secondary,
                strokeWidth: 2,
                displacement: 20,
                child: _buildBody(theme, context),
              ),
            ),
            Obx(() => _buildActionButtons(theme, context)),
          ],
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BText(
                text: 'booking_detail',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.secondary,
                isLocalized: true,
              ),
              Obx(
                () => Text(
                  controller.bookingDetail.value?.bookingRef ?? '',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────────

  Widget _buildBody(ThemeData theme, BuildContext context) {
    return Obx(() {
      // ── Loading ───────────────────────────────────────────
      if (controller.isLoading.value &&
          controller.bookingDetail.value == null) {
        return const MyBookingDetailShimmer();
      }

      // ── Error ─────────────────────────────────────────────
      if (controller.errorMessage.value.isNotEmpty) {
        return _buildError(theme);
      }

      // ── No data guard ─────────────────────────────────────
      if (controller.bookingDetail.value == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 48.sp, color: theme.dividerColor),
              Gap(12.h),
              Text(
                'No booking data found',
                style: TextStyle(fontSize: 13.sp, color: theme.dividerColor),
              ),
              Gap(16.h),
              ElevatedButton(
                onPressed: () => controller.fetchDetail(),
                child: Text('Retry'),
              ),
            ],
          ),
        );
      }

      // ── Content ───────────────────────────────────────────
      return SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            if (controller.currentStatus.value == 'pending' ||
                controller.currentStatus.value == 'accepted' ||
                controller.currentStatus.value == 'ongoing') ...[
              _buildStepper(theme),
              Gap(14.h),
            ],
            _buildMainCard(theme),
            if (controller.currentStatus.value == 'completed') ...[
              Gap(16.h),
              _buildRatingSection(theme, context),
            ],
          ],
        ),
      );
    });
  }

  // ── Error State ───────────────────────────────────────────────────────────

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
            onPressed: () => controller.fetchDetail(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child: Text(
              'retry'.tr,
              style: TextStyle(
                fontSize: 13.sp,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Rating Section ────────────────────────────────────────────────────────

  Widget _buildRatingSection(ThemeData theme, BuildContext context) {
    final b = controller.booking;
    final tag = 'review_${b.id}';

    if (!Get.isRegistered<ReviewController>(tag: tag)) {
      // Get AddReviewUseCase from dependency injection
      AddReviewUseCase? addReviewUseCase;

      if (Get.isRegistered<AddReviewUseCase>()) {
        addReviewUseCase = Get.find<AddReviewUseCase>();
        print('✅ AddReviewUseCase found in GetX');
      } else {
        // If not registered, create it manually
        print('⚠️ AddReviewUseCase not registered, creating manually...');
        final remoteDataSource = ReviewRemoteDataSourceImpl();
        final repository = ReviewRepositoryImpl(ds: remoteDataSource);
        addReviewUseCase = AddReviewUseCase(repository);
        // Register it for future use
        Get.put(addReviewUseCase, permanent: true);
      }

      Get.put(ReviewController(addReviewUseCase: addReviewUseCase), tag: tag);
      _isReviewControllerRegistered = true;
      print('✅ ReviewController registered for booking: ${b.id}');
    }

    final ratingController = Get.find<ReviewController>(tag: tag);

    return Container(
      width: double.infinity,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_rounded,
                  color: const Color(0xFF059669),
                  size: 16.sp,
                ),
                Gap(6.w),
                Text(
                  'rate_your_trip'.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF065F46),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),

            // Inside _buildRatingSection → replace the Obx content
            child: Obx(() {
              // ── State 1: Already reviewed / submitted ─────────────────
              if (ratingController.isSubmitted.value) {
                return _buildRatingSuccessView(
                  theme,
                  isAlreadyReviewed: ratingController.isAlreadyReviewed.value,
                );
              }

              // ── State 2: Validation/API error ────────────────────────
              if (ratingController.errorMessage.value.isNotEmpty) {
                return Column(
                  children: [
                    // Error banner
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 18.sp,
                          ),
                          Gap(8.w),
                          Expanded(
                            child: Text(
                              ratingController.errorMessage.value,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: ratingController.clearError,
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(16.h),
                    // Show the rating form again so user can retry
                    _buildRatingForm(theme, ratingController, b),
                  ],
                );
              }

              // ── State 3: Rating form ──────────────────────────────────
              return _buildRatingForm(theme, ratingController, b);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingForm(
    ThemeData theme,
    ReviewController ratingController,
    MyBookingDetailEntity b,
  ) {
    return Column(
      children: [
        // Driver info row
        Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.person_rounded,
                color: theme.colorScheme.primary,
                size: 24.sp,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b.driverName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    b.vehicleName,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: theme.dividerColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'trip_completed'.tr,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF059669),
                ),
              ),
            ),
          ],
        ),

        Gap(20.h),

        // Stars — require rating before submit
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final starIndex = i + 1;
            return Obx(
              () => GestureDetector(
                onTap: () => ratingController.setRating(starIndex),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: AnimatedScale(
                    scale: ratingController.selectedRating.value >= starIndex
                        ? 1.2
                        : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      ratingController.selectedRating.value >= starIndex
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 38.sp,
                      color: ratingController.selectedRating.value >= starIndex
                          ? const Color(0xFFF59E0B)
                          : theme.dividerColor.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        Gap(4.h),

        // "Please select a rating" hint — shown when no star selected
        Obx(
          () => ratingController.selectedRating.value == 0
              ? Text(
                  'select_rating_hint'.tr,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: theme.dividerColor.withValues(alpha: 0.6),
                  ),
                )
              : Text(
                  ratingController.ratingLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _getRatingLabelColor(
                      ratingController.selectedRating.value,
                    ),
                  ),
                ),
        ),

        Gap(16.h),

        // Comment field
        TextField(
          controller: ratingController.commentController,
          onChanged: (v) => ratingController.commentText.value = v,
          maxLines: 3,
          maxLength: 150,
          decoration: InputDecoration(
            hintText: 'review_hint'.tr,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
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
            counterStyle: TextStyle(fontSize: 9.sp, color: theme.dividerColor),
          ),
        ),

        Gap(16.h),

        // Submit button — disabled until star selected
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => ElevatedButton(
              onPressed:
                  ratingController.canSubmit &&
                      !ratingController.isSubmitting.value
                  ? () => ratingController.submitReview(
                      bookingId: b.id,
                      vehicleId: b.vehicleId,
                    )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                disabledBackgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.35,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: ratingController.isSubmitting.value
                  ? SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.secondary,
                      ),
                    )
                  : Text(
                      'submit_review'.tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
            ),
          ),
        ),

        Gap(8.h),

        // Skip
        GestureDetector(
          onTap: ratingController.skip,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Text(
              'skip'.tr,
              style: TextStyle(fontSize: 12.sp, color: theme.dividerColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSuccessView(
    ThemeData theme, {
    bool isAlreadyReviewed = false,
  }) {
    final myReview = controller.myReview.value;

    return Column(
      children: [
        // ── Icon ────────────────────────────────────────────────
        Center(
          child: Container(
            width: 56.w,
            height: 56.h,
            decoration: BoxDecoration(
              color: isAlreadyReviewed
                  ? const Color(0xFFEDE9FE)
                  : const Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: isAlreadyReviewed
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF059669),
              size: 28.sp,
            ),
          ),
        ),

        Gap(12.h),

        // ── Title ────────────────────────────────────────────────
        Text(
          isAlreadyReviewed ? 'already_reviewed'.tr : 'review_submitted'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),

        Gap(4.h),

        Text(
          isAlreadyReviewed
              ? 'already_reviewed_msg'.tr
              : 'review_submitted_msg'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11.sp, color: theme.dividerColor),
        ),

        // ── Submitted review card ─────────────────────────────────
        if (myReview != null) ...[
          Gap(16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stars + label row ──────────────────────────
                Row(
                  children: [
                    // Stars
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < myReview.rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 18.sp,
                          color: i < myReview.rating
                              ? const Color(0xFFF59E0B)
                              : theme.dividerColor.withValues(alpha: 0.3),
                        );
                      }),
                    ),
                    Gap(8.w),
                    // Rating label badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getRatingLabelColor(
                          myReview.rating,
                        ).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _getRatingText(myReview.rating),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: _getRatingLabelColor(myReview.rating),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Date
                    Text(
                      myReview.date,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: theme.dividerColor,
                      ),
                    ),
                  ],
                ),

                // ── Comment ────────────────────────────────────
                if (myReview.comment.isNotEmpty) ...[
                  Gap(10.h),
                  Text(
                    myReview.comment,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── Helper: rating text ───────────────────────────────────────────────────────
  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor'.tr;
      case 2:
        return 'Fair'.tr;
      case 3:
        return 'Good'.tr;
      case 4:
        return 'Very Good'.tr;
      case 5:
        return 'Excellent'.tr;
      default:
        return '';
    }
  }

  Color _getRatingLabelColor(int rating) {
    switch (rating) {
      case 1:
      case 2:
        return const Color(0xFFEF4444);
      case 3:
        return const Color(0xFFF59E0B);
      case 4:
      case 5:
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  // ── Stepper ───────────────────────────────────────────────────────────────

  Widget _buildStepper(ThemeData theme) {
    final steps = [
      'step_booked'.tr,
      'step_accepted'.tr,
      'step_ongoing'.tr,
      'step_delivered'.tr,
    ];

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'trip_status'.tr,
            style: TextStyle(fontSize: 11.sp, color: theme.dividerColor),
          ),
          Gap(14.h),
          Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                final lineIdx = i ~/ 2;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: controller.stepIndex > lineIdx
                        ? theme.colorScheme.primary
                        : theme.dividerColor.withValues(alpha: 0.2),
                  ),
                );
              }
              final si = i ~/ 2;
              final isDone = controller.stepIndex > si;
              final isActive = controller.stepIndex == si;
              return Column(
                children: [
                  Container(
                    width: 26.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? theme.colorScheme.primary
                          : isActive
                          ? theme.colorScheme.secondary
                          : theme.dividerColor.withValues(alpha: 0.1),
                      border: isActive
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: isDone
                          ? Icon(
                              Icons.check_rounded,
                              color: theme.colorScheme.secondary,
                              size: 13.sp,
                            )
                          : Container(
                              width: isActive ? 8.w : 6.w,
                              height: isActive ? 8.h : 6.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive
                                    ? theme.colorScheme.primary
                                    : theme.dividerColor.withValues(alpha: 0.4),
                              ),
                            ),
                    ),
                  ),
                  Gap(5.h),
                  SizedBox(
                    width: 56.w,
                    child: Text(
                      steps[si],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: isDone || isActive
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Main Card ─────────────────────────────────────────────────────────────

  Widget _buildMainCard(ThemeData theme) {
    final b = controller.booking;

    return Container(
      width: double.infinity,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.06),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Center(
              child: Text(
                '${'booking_id'.tr}: ${b.bookingRef}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BText(
                  text: 'driver_details',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                  isLocalized: true,
                ),
                Gap(12.h),
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.local_shipping_rounded,
                        color: theme.colorScheme.primary,
                        size: 26.sp,
                      ),
                    ),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BText(
                          text: b.vehicleName,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          isLocalized: false,
                        ),
                        Gap(2.h),
                        BText(
                          text: b.driverName,
                          fontSize: 12.sp,
                          color: theme.dividerColor,
                          isLocalized: false,
                        ),
                        Gap(5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 11.sp,
                                color: const Color(0xFFF59E0B),
                              ),
                              Gap(3.w),
                              BText(
                                text: b.driverRating,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                                isLocalized: false,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Gap(14.h),
                Divider(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                  height: 1,
                ),
                Gap(12.h),
                BText(
                  text: 'trip_details',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                  isLocalized: true,
                ),
                Gap(12.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [_dot(AppTheme.green), _line(theme)]),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _lbl('pickup'.tr, theme),
                        Gap(2.h),
                        _addr(b.pickupAddress),
                      ],
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dot(AppTheme.red),
                    Gap(10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _lbl('drop'.tr, theme),
                        Gap(2.h),
                        _addr(b.dropAddress),
                      ],
                    ),
                  ],
                ),
                Gap(14.h),
                Row(
                  children: [
                    Expanded(child: _infoBox(theme, 'date'.tr, b.displayDate)),
                    Gap(8.w),
                    Expanded(child: _infoBox(theme, 'time'.tr, b.displayTime)),
                    Gap(8.w),
                    Expanded(child: _infoBox(theme, 'eta'.tr, b.displayEta)),
                  ],
                ),
                Gap(14.h),
                Divider(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                  height: 1,
                ),
                Gap(12.h),
                BText(
                  text: 'payment',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                  isLocalized: true,
                ),
                Gap(10.h),
                Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.payment_rounded,
                        color: theme.colorScheme.primary,
                        size: 20.sp,
                      ),
                    ),
                    Gap(12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BText(
                          text: b.displayPaymentMethod,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          isLocalized: false,
                        ),
                        BText(
                          text: b.paymentNote != null
                              ? b.paymentNote!.tr
                              : 'pay_on_arrival'.tr,
                          fontSize: 10.sp,
                          color: theme.dividerColor,
                          isLocalized: false,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'total'.tr,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: theme.dividerColor,
                          ),
                        ),
                        BText(
                          text: b.displayAmount,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                          isLocalized: false,
                        ),
                      ],
                    ),
                  ],
                ),
                if (b.specialInstructions != null &&
                    b.specialInstructions!.isNotEmpty) ...[
                  Gap(14.h),
                  Divider(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                    height: 1,
                  ),
                  Gap(12.h),
                  BText(
                    text: 'special_instructions',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                    isLocalized: true,
                  ),
                  Gap(6.h),
                  Text(
                    b.specialInstructions!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
                if (b.driverRejectionReason != null &&
                    b.driverRejectionReason!.isNotEmpty) ...[
                  Gap(14.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 14.sp,
                          color: const Color(0xFF991B1B),
                        ),
                        Gap(6.w),
                        Expanded(
                          child: Text(
                            b.driverRejectionReason!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF991B1B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _dot(Color c) => Container(
    width: 14.w,
    height: 14.h,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.25),
      shape: BoxShape.circle,
    ),
    child: Container(
      width: 7.w,
      height: 7.h,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    ),
  );

  Widget _line(ThemeData t) => Container(
    width: 1.5.w,
    height: 38.h,
    color: t.dividerColor.withValues(alpha: 0.25),
  );

  Widget _lbl(String s, ThemeData t) => Text(
    s,
    style: TextStyle(fontSize: 10.sp, color: t.dividerColor),
  );

  Widget _addr(String s) => SizedBox(
    width: 220.w,
    child: BText(
      text: s,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      isLocalized: false,
    ),
  );

  Widget _infoBox(ThemeData t, String label, String value) => Container(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    decoration: BoxDecoration(
      color: t.dividerColor.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: t.dividerColor),
        ),
        Gap(4.h),
        BText(
          text: value,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          isLocalized: false,
        ),
      ],
    ),
  );

  // ── Action Buttons ────────────────────────────────────────────────────────

  Widget _buildActionButtons(ThemeData theme, BuildContext context) {
    if (controller.isLoading.value) {
      return Container(
        color: theme.colorScheme.secondary,
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      );
    }

    if (controller.bookingDetail.value == null) return const SizedBox.shrink();

    final status = controller.currentStatus.value;

    return Container(
      color: theme.colorScheme.secondary,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == 'pending' ||
              status == 'accepted' ||
              status == 'ongoing') ...[
            BButton(
              text: 'call_driver',
              onTap: controller.callDriver,
              isOutline: true,
              prefixIcon: Icon(Icons.call, color: theme.primaryColor),
            ),
            if (status == 'ongoing') ...[
              Gap(8.h),
              BButton(
                text: 'track_driver',
                onTap: controller.trackDriver,
                prefixIcon: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                ),
              ),
            ],
            if (status == 'pending') ...[
              Gap(8.h),
              BButton(
                text: 'cancel_booking',
                onTap: () => _showCancelDialog(theme),
                isOutline: true,
                prefixIcon: Icon(Icons.cancel_outlined, color: AppTheme.red),
              ),
            ],
          ],
          if (status == 'completed')
            BButton(
              text: 'rebook',
              onTap: controller.rebook,
              prefixIcon: const Icon(Icons.refresh_rounded),
            ),
          if (status == 'cancelled' || status == 'rejected')
            BButton(
              text: 'rebook',
              onTap: controller.rebook,
              isOutline: true,
              prefixIcon: Icon(
                Icons.refresh_rounded,
                color: theme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  void _showCancelDialog(ThemeData theme) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'cancel_booking_title'.tr,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.red,
          ),
        ),
        content: Text(
          'cancel_booking_msg'.tr,
          style: TextStyle(fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('no'.tr, style: TextStyle(color: theme.dividerColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cancelBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'yes_cancel'.tr,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
