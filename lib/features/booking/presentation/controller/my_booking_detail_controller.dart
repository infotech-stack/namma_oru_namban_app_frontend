// lib/features/booking/presentation/controller/my_booking_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_detail_entity.dart';
import 'package:userapp/features/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:userapp/features/review/driver_review/presentation/widget/review_bottom_sheet.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';

class MyBookingDetailController extends GetxController {
  final GetBookingDetailUseCase _getBookingDetailUseCase;

  // Make bookingId nullable and get from arguments
  int? _bookingId;

  int get bookingId {
    if (_bookingId == null) {
      _bookingId = _extractBookingId();
    }
    return _bookingId ?? 0;
  }

  MyBookingDetailController({
    required GetBookingDetailUseCase getBookingDetailUseCase,
  }) : _getBookingDetailUseCase = getBookingDetailUseCase;

  // ── State ─────────────────────────────────────────────────────
  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final Rx<MyBookingDetailEntity?> bookingDetail = Rx<MyBookingDetailEntity?>(
    null,
  );
  final currentStatus = ''.obs;

  // ── Shorthand getter ──────────────────────────────────────────
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
      print('🔍 Extracting booking ID from arguments');
      print('🔍 Get.arguments: ${Get.arguments}');
      print('🔍 Get.arguments type: ${Get.arguments.runtimeType}');

      // Case 1: Direct int
      if (Get.arguments is int) {
        extractedId = Get.arguments as int;
        print('✅ Got ID from direct int: $extractedId');
      }
      // Case 2: String
      else if (Get.arguments is String) {
        extractedId = int.tryParse(Get.arguments as String);
        print('✅ Got ID from string: $extractedId');
      }
      // Case 3: Map with 'id' key
      else if (Get.arguments is Map) {
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
        print('✅ Got ID from map: $extractedId');
      }

      if (extractedId == null || extractedId <= 0) {
        print('❌ No valid booking ID found in arguments');
      }

      return extractedId ?? 0;
    } catch (e) {
      print('❌ Error extracting booking ID: $e');
      return 0;
    }
  }

  // ── Fetch ─────────────────────────────────────────────────────
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
    } else {
      errorMessage.value = result.error ?? 'Failed to load booking detail';
      AppLogger.error(
        'MyBookingDetailController → fetchDetail: FAILED — ${errorMessage.value}',
      );
    }

    isLoading.value = false;
  }

  // ── Refresh Method ──────────────────────────────────────────
  Future<void> refreshDetail() async {
    print('🔄 Refreshing booking detail...');
    await fetchDetail();
  }

  // ── Step index for stepper UI ─────────────────────────────────
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

  void callDriver() {
    final mobile = bookingDetail.value?.driverMobile ?? '';
    AppLogger.info('MyBookingDetailController → callDriver: $mobile');
    Get.snackbar(
      'calling_driver'.tr,
      bookingDetail.value?.driverName ?? '',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: launchUrl(Uri.parse('tel:$mobile'));
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
    Get.snackbar(
      'Book Again',
      'Redirecting to booking...',
      snackPosition: SnackPosition.BOTTOM,
    );
    AppSnackbar.warning(
      'Live tracking coming soon',
      title: 'Track Driver',
      isRaw: true,
    );
  }

  // ── Trip complete → Review sheet ──────────────────────────────
  // Future<void> onTripCompleted(BuildContext context) async {
  //   currentStatus.value = 'completed';
  //   await Future.delayed(const Duration(milliseconds: 500));
  //
  //   if (context.mounted && bookingDetail.value != null) {
  //     final b = bookingDetail.value!;
  //     await ReviewBottomSheet.show(
  //       context: context,
  //       bookingId: b.id,
  //       driverName: b.driverName,
  //       vehicleName: b.vehicleName,
  //       totalAmount: b.displayAmount,
  //     );
  //   }
  // }
}
