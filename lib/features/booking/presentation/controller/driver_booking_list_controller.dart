// lib/features/driver/bookings/presentation/controller/driver_booking_list_controller.dart

import 'package:get/get.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking/data/model/driver_booking_model.dart';

class DriverBookingListController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final selectedTab = 0.obs;

  final List<String> tabKeys = [
    'tab_all',
    'tab_pending',
    'tab_active',
    'tab_done',
  ];

  final List<String> statusFilters = ['all', 'pending', 'ongoing', 'completed'];

  // ── Computed ───────────────────────────────────────────────────────────────
  List<DriverBookingModel> get filteredBookings {
    final filter = statusFilters[selectedTab.value];
    if (filter == 'all') return dummyDriverBookings;
    if (filter == 'ongoing') {
      return dummyDriverBookings
          .where((b) => b.status == 'ongoing' || b.status == 'accepted')
          .toList();
    }
    return dummyDriverBookings.where((b) => b.status == filter).toList();
  }

  DriverBookingModel? get activeBooking =>
      dummyDriverBookings.where((b) => b.isActive).firstOrNull;

  // ── Actions ────────────────────────────────────────────────────────────────
  void selectTab(int index) => selectedTab.value = index;

  void goToStatus(DriverBookingModel booking) {
    Get.toNamed(Routes.myBookingStatus, arguments: booking);
  }
}
