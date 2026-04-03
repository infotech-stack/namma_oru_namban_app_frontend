// lib/features/booking/presentation/controller/my_booking_list_controller.dart
// ════════════════════════════════════════════════════════════════
//  MY BOOKING LIST CONTROLLER — Presentation Layer
// ════════════════════════════════════════════════════════════════

import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_entity.dart';
import 'package:userapp/features/booking/domain/usecases/get_my_bookings_usecase.dart';

class MyBookingListController extends GetxController {
  final GetMyBookingsUseCase _getMyBookingsUseCase;

  MyBookingListController(this._getMyBookingsUseCase);

  // ── Tab config ────────────────────────────────────────────────
  final List<String> tabKeys = ['tab_all', 'tab_active', 'tab_past'];

  // ── State ─────────────────────────────────────────────────────
  final RxList<MyBookingEntity> bookings = <MyBookingEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxInt totalBookings = 0.obs;
  final RxBool hasMore = true.obs;

  final int pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    AppLogger.info('MyBookingListController → onInit');
    fetchBookings(reset: true);
  }

  // ── Refresh Method ──────────────────────────────────────────
  Future<void> refreshDetail() async {
    print('🔄 Refreshing booking detail...');
    await fetchBookings(reset: true);
  }
  // ── Fetch ─────────────────────────────────────────────────────
  // lib/features/booking/presentation/controller/my_booking_list_controller.dart

  Future<void> fetchBookings({bool reset = false}) async {
    if (isLoading.value) return;
    if (!hasMore.value && !reset) return;

    isLoading.value = true;
    errorMessage.value = '';

    if (reset) {
      currentPage.value = 0;
      bookings.clear();
      hasMore.value = true;
    }

    AppLogger.info(
      'MyBookingListController → fetchBookings: '
      'page=${currentPage.value}, limit=$pageSize',
    );

    final result = await _getMyBookingsUseCase(
      limit: pageSize,
      offset: currentPage.value * pageSize,
    );

    if (result.isSuccess && result.data != null) {
      final response = result.data!;

      // 🔍 DEBUG: AppLogger.info first booking to see what IDs we have
      if (response.bookings.isNotEmpty) {
        AppLogger.info('🔍 First booking data:');
        AppLogger.info('  - ID: ${response.bookings.first.id}');
        AppLogger.info('  - BookingRef: ${response.bookings.first.bookingRef}');
        AppLogger.info('  - Status: ${response.bookings.first.status}');
        //AppLogger.info('  - Full JSON: ${response.bookings.first.toJson()}');
      }

      bookings.addAll(response.bookings);
      totalBookings.value = response.total;
      hasMore.value = bookings.length < totalBookings.value;
      currentPage.value++;

      AppLogger.info(
        'MyBookingListController → fetchBookings: success — '
        '${response.bookings.length} loaded, total=${response.total}',
      );
    } else {
      errorMessage.value = result.error ?? 'Failed to load bookings';
      AppLogger.error(
        'MyBookingListController → fetchBookings: FAILED — ${errorMessage.value}',
      );
    }

    isLoading.value = false;
  }

  // ── Refresh ───────────────────────────────────────────────────
  Future<void> refreshBookings() => fetchBookings(reset: true);

  // ── Load More (pagination) ────────────────────────────────────
  Future<void> loadMore() async {
    if (hasMore.value && !isLoading.value) {
      await fetchBookings();
    }
  }

  // ── Tab filtering (no Rx needed — BTabController owns tab state)
  List<MyBookingEntity> bookingsForTab(int tabIndex) {
    switch (tabIndex) {
      case 1: // Active
        return bookings.where((b) => b.isActive).toList();
      case 2: // Past
        return bookings
            .where(
              (b) =>
                  b.status == 'completed' ||
                  b.status == 'cancelled' ||
                  b.status == 'rejected',
            )
            .toList();
      default: // All
        return bookings.toList();
    }
  }

  // ── Computed ──────────────────────────────────────────────────
  MyBookingEntity? get activeBooking =>
      bookings.firstWhereOrNull((b) => b.isActive);

  // ── Actions ───────────────────────────────────────────────────
  void goToDetail(MyBookingEntity booking) {
    AppLogger.info('🔍 ========== NAVIGATION DEBUG ==========');
    AppLogger.info('🔍 Booking object: ${booking.runtimeType}');
    AppLogger.info('🔍 Booking ID: ${booking.id}');
    AppLogger.info('🔍 Booking Ref: ${booking.bookingRef}');
    AppLogger.info('🔍 Arguments to pass: {"id": ${booking.id}}');

    // Method 1: Pass as Map with 'id' key
    Get.toNamed(Routes.myBookingStatus, arguments: {'id': booking.id});
  }
}
