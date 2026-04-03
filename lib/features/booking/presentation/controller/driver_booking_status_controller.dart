// lib/features/driver/bookings/presentation/controller/driver_booking_status_controller.dart

import 'dart:ui';

import 'package:get/get.dart';
import '../../data/model/driver_booking_model.dart';

class DriverBookingStatusController extends GetxController {
  final DriverBookingModel booking;
  DriverBookingStatusController(this.booking);

  // ── State ──────────────────────────────────────────────────────────────────
  final currentStatus = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentStatus.value = booking.status;
  }

  // 0 = accepted, 1 = ongoing, 2 = completed
  int get stepIndex {
    switch (currentStatus.value) {
      case 'accepted':
        return 0;
      case 'ongoing':
        return 1;
      case 'completed':
        return 2;
      default:
        return -1;
    }
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> acceptBooking() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    currentStatus.value = 'accepted';
    isLoading.value = false;
    Get.snackbar(
      'booking_accepted'.tr,
      'booking_accepted_msg'.tr,
      backgroundColor: const Color(0xFF10B981),
      colorText: const Color(0xFFFFFFFF),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> rejectBooking({String reason = ''}) async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    currentStatus.value = 'rejected';
    isLoading.value = false;
    Get.snackbar(
      'booking_rejected'.tr,
      reason.isEmpty ? booking.bookingRef : reason,
      backgroundColor: const Color(0xFFEF4444),
      colorText: const Color(0xFFFFFFFF),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> startTrip() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    currentStatus.value = 'ongoing';
    isLoading.value = false;
    Get.snackbar(
      'trip_started'.tr,
      'trip_started_msg'.tr,
      backgroundColor: const Color(0xFF6C3CE1),
      colorText: const Color(0xFFFFFFFF),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> completeTrip() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    currentStatus.value = 'completed';
    isLoading.value = false;
    Get.snackbar(
      'trip_completed'.tr,
      'trip_completed_msg'.tr,
      backgroundColor: const Color(0xFF10B981),
      colorText: const Color(0xFFFFFFFF),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void callUser() {
    Get.snackbar(
      'calling'.tr,
      booking.userMobile,
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: url_launcher
    // launchUrl(Uri.parse('tel:${booking.userMobile}'));
  }
}
