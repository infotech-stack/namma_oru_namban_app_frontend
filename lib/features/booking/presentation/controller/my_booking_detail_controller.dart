// lib/features/booking/presentation/controller/my_booking_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_detail_entity.dart';
import 'package:userapp/features/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:userapp/features/review/driver_review/data/datasources/review_datasource.dart';
import 'package:userapp/features/review/driver_review/data/repositories/review_repository_impl.dart';
import 'package:userapp/features/review/driver_review/domain/entities/review_entity.dart';
import 'package:userapp/features/review/driver_review/domain/usecases/add_review_usecase.dart';
import 'package:userapp/features/review/driver_review/domain/usecases/get_reviews_usecase.dart';
import 'package:userapp/features/review/driver_review/presentation/review_controller.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class MyBookingDetailController extends GetxController {
  final GetBookingDetailUseCase _getBookingDetailUseCase;
  final GetReviewsUseCase _getReviewsUseCase;

  int? _bookingId;

  int get bookingId {
    _bookingId ??= _extractBookingId();
    return _bookingId ?? 0;
  }

  MyBookingDetailController({
    required GetBookingDetailUseCase getBookingDetailUseCase,
    required GetReviewsUseCase getReviewsUseCase,
  }) : _getBookingDetailUseCase = getBookingDetailUseCase,
       _getReviewsUseCase = getReviewsUseCase;

  // ── State ─────────────────────────────────────────────────────
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final Rx<MyBookingDetailEntity?> bookingDetail = Rx<MyBookingDetailEntity?>(
    null,
  );
  final currentStatus = ''.obs;

  // ── Review state ──────────────────────────────────────────────
  final isAlreadyReviewed = false.obs;
  final isCheckingReview = false.obs;

  MyBookingDetailEntity get booking => bookingDetail.value!;

  @override
  void onInit() {
    super.onInit();
    AppLogger.info('MyBookingDetailController → onInit: bookingId=$bookingId');
    if (bookingId > 0) {
      fetchDetail();
    } else {
      errorMessage.value = 'Invalid booking ID';
      isLoading.value = false;
    }
  }

  // ── Extract Booking ID from arguments ─────────────────────────
  int _extractBookingId() {
    int? extractedId;

    try {
      AppLogger.info(
        'MyBookingDetailController → extractBookingId: ${Get.arguments}',
      );

      if (Get.arguments is int) {
        extractedId = Get.arguments as int;
      } else if (Get.arguments is String) {
        extractedId = int.tryParse(Get.arguments as String);
      } else if (Get.arguments is Map) {
        final args = Get.arguments as Map;
        if (args.containsKey('id')) {
          extractedId = args['id'] is int
              ? args['id']
              : int.tryParse(args['id'].toString());
        } else if (args.containsKey('bookingId')) {
          extractedId = args['bookingId'] is int
              ? args['bookingId']
              : int.tryParse(args['bookingId'].toString());
        }
      }

      AppLogger.info(
        'MyBookingDetailController → extractBookingId: result=$extractedId',
      );
      return extractedId ?? 0;
    } catch (e) {
      AppLogger.error('MyBookingDetailController → extractBookingId: error=$e');
      return 0;
    }
  }

  // ── Fetch booking detail ──────────────────────────────────────
  Future<void> fetchDetail() async {
    if (bookingId <= 0) {
      errorMessage.value = 'Invalid booking ID';
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    AppLogger.info('MyBookingDetailController → fetchDetail: id=$bookingId');

    final result = await _getBookingDetailUseCase(bookingId);

    if (result.isSuccess && result.data != null) {
      bookingDetail.value = result.data;
      currentStatus.value = result.data!.status;

      AppLogger.info(
        'MyBookingDetailController → fetchDetail: success — '
        'status=${result.data!.status}',
      );

      // Check review status if trip is completed
      if (currentStatus.value == 'completed') {
        await _checkIfAlreadyReviewed(result.data!.vehicleId);
      }
    } else {
      errorMessage.value = result.error ?? 'Failed to load booking detail';
      AppLogger.error(
        'MyBookingDetailController → fetchDetail: FAILED — ${errorMessage.value}',
      );
    }

    isLoading.value = false;
  }

  // ── Check if already reviewed ─────────────────────────────────
  // In MyBookingDetailController — add myReview state

  // ── Review state ──────────────────────────────────────────────

  final Rx<MyReviewEntity?> myReview = Rx<MyReviewEntity?>(null); // ← new

  // ── Update _checkIfAlreadyReviewed ────────────────────────────
  Future<void> _checkIfAlreadyReviewed(int vehicleId) async {
    try {
      isCheckingReview.value = true;

      AppLogger.info(
        'MyBookingDetailController → _checkIfAlreadyReviewed: vehicleId=$vehicleId',
      );

      final result = await _getReviewsUseCase(vehicleId);

      if (result.isSuccess && result.data != null) {
        final data = result.data!;

        // Use hasReviewed flag directly from API ✅
        isAlreadyReviewed.value = data.hasReviewed;
        myReview.value = data.myReview; // ← store the review

        AppLogger.info(
          'MyBookingDetailController → _checkIfAlreadyReviewed: '
          'hasReviewed=${data.hasReviewed}, '
          'myReview=${data.myReview?.rating}★ "${data.myReview?.comment}"',
        );

        if (isAlreadyReviewed.value) {
          _markReviewControllerAsSubmitted();
        }
      }
    } catch (e) {
      AppLogger.error(
        'MyBookingDetailController → _checkIfAlreadyReviewed: error=$e',
      );
    } finally {
      isCheckingReview.value = false;
    }
  }

  // ── Pre-mark ReviewController as already submitted ────────────
  void _markReviewControllerAsSubmitted() {
    final detail = bookingDetail.value;
    if (detail == null) return;

    final tag = 'review_${detail.id}';

    try {
      ReviewController rc;

      if (Get.isRegistered<ReviewController>(tag: tag)) {
        rc = Get.find<ReviewController>(tag: tag);
      } else {
        // Build ReviewController with use case
        AddReviewUseCase addReviewUseCase;

        if (Get.isRegistered<AddReviewUseCase>()) {
          addReviewUseCase = Get.find<AddReviewUseCase>();
        } else {
          final ds = ReviewRemoteDataSourceImpl();
          final repo = ReviewRepositoryImpl(ds: ds);
          addReviewUseCase = AddReviewUseCase(repo);
          Get.put(addReviewUseCase, permanent: true);
        }

        rc = Get.put(
          ReviewController(addReviewUseCase: addReviewUseCase),
          tag: tag,
        );
      }

      // Set submitted state
      rc.isSubmitted.value = true;
      rc.isAlreadyReviewed.value = true;

      AppLogger.info(
        'MyBookingDetailController → _markReviewControllerAsSubmitted: '
        'tag=$tag — done',
      );
    } catch (e) {
      AppLogger.error(
        'MyBookingDetailController → _markReviewControllerAsSubmitted: error=$e',
      );
    }
  }

  // ── Refresh ───────────────────────────────────────────────────
  Future<void> refreshDetail() async {
    AppLogger.info('MyBookingDetailController → refreshDetail');
    // Reset review state on refresh
    isAlreadyReviewed.value = false;
    await fetchDetail();
  }

  // ── Step index ────────────────────────────────────────────────
  int get stepIndex {
    switch (currentStatus.value) {
      case 'pending':
        return 0;
      case 'accepted':
        return 1;
      case 'ongoing':
        return 2;
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }

  // ── Actions ───────────────────────────────────────────────────
  Future<void> cancelBooking() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: call cancel API
    currentStatus.value = 'cancelled';
    isLoading.value = false;
    Get.snackbar(
      'booking_cancelled'.tr,
      'booking_cancelled_msg'.tr,
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> callDriver() async {
    final mobile = bookingDetail.value?.driverMobile ?? '';

    if (mobile.isEmpty) {
      AppSnackbar.warning('driver_number_unavailable'.tr);
      return;
    }

    final uri = Uri.parse('tel:$mobile');

    AppLogger.info('MyBookingDetailController → callDriver: $mobile');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      AppSnackbar.error('cannot_call'.tr);
      AppLogger.error(
        'MyBookingDetailController → callDriver: cannot launch $uri',
      );
    }
  }

  void trackDriver() {
    AppLogger.info('MyBookingDetailController → trackDriver');
    AppSnackbar.warning(
      'Live tracking coming soon',
      title: 'Track Driver',
      isRaw: true,
    );
  }

  void rebook() {
    AppLogger.info('MyBookingDetailController → rebook');
    AppSnackbar.warning(
      'Redirecting to booking...',
      title: 'Book Again',
      isRaw: true,
    );
  }
}
