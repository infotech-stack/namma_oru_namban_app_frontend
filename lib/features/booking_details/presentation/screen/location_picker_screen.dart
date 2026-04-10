// lib/features/booking/unified/screens/location_picker_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:userapp/utils/services/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RxList<Location> _searchResults = <Location>[].obs;
  final RxList<String> _addressResults = <String>[].obs;
  final RxBool _isSearching = false.obs;
  final RxString _selectedAddress = ''.obs;
  double? _selectedLat;
  double? _selectedLng;

  // Add instance of new LocationService
  final LocationService _locationService = LocationService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchAddress(String query) async {
    if (query.trim().length < 3) {
      _searchResults.clear();
      _addressResults.clear();
      return;
    }

    _isSearching.value = true;

    try {
      final locations = await locationFromAddress(query);
      _searchResults.assignAll(locations);

      final addresses = <String>[];
      for (final loc in locations.take(5)) {
        // Use new method - call instance method directly
        final address = await _locationService.getAddressFromCoordinates(
          loc.latitude,
          loc.longitude,
        );
        addresses.add(address);
      }
      _addressResults.assignAll(addresses);
    } catch (e) {
      _searchResults.clear();
      _addressResults.clear();
    }

    _isSearching.value = false;
  }

  Future<void> _useCurrentLocation() async {
    _isSearching.value = true;

    // Use new method
    final locationResult = await _locationService.getCurrentLocation();
    if (locationResult != null) {
      _selectedLat = locationResult.lat;
      _selectedLng = locationResult.lng;
      _selectedAddress.value = locationResult.address;
      _searchController.text = locationResult.address;
      _searchResults.clear();
      _addressResults.clear();
    } else {
      Get.snackbar(
        'error'.tr,
        'enable_location'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    _isSearching.value = false;
  }

  void _selectLocation(int index) {
    if (index >= _searchResults.length) return;
    final loc = _searchResults[index];
    final address = _addressResults[index];

    _selectedLat = loc.latitude;
    _selectedLng = loc.longitude;
    _selectedAddress.value = address;
    _searchController.text = address;
    _searchResults.clear();
    _addressResults.clear();
  }

  void _confirmLocation() {
    if (_selectedLat == null || _selectedLng == null) {
      Get.snackbar(
        'error'.tr,
        'select_location_first'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.back(
      result: {
        'address': _selectedAddress.value,
        'lat': _selectedLat!,
        'lng': _selectedLng!,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'select_drop_location'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Search Bar ──
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Search field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Icon(
                          Icons.search_rounded,
                          color: theme.colorScheme.primary,
                          size: 20.sp,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'search_location'.tr,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.h,
                            ),
                            hintStyle: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                          style: TextStyle(fontSize: 13.sp),
                          onChanged: _searchAddress,
                        ),
                      ),
                      Obx(
                        () => _isSearching.value
                            ? Padding(
                                padding: EdgeInsets.all(12.w),
                                child: SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  size: 18.sp,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _searchResults.clear();
                                  _addressResults.clear();
                                  _selectedAddress.value = '';
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                Gap(10.h),
                // Current location button
                GestureDetector(
                  onTap: _useCurrentLocation,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location_rounded,
                          color: theme.colorScheme.primary,
                          size: 18.sp,
                        ),
                        Gap(10.w),
                        Text(
                          'use_current_location'.tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Results / Empty State ──
          Expanded(
            child: Obx(() {
              // Empty state
              if (_addressResults.isEmpty && _selectedAddress.value.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_searching_rounded,
                        size: 48.sp,
                        color: Colors.grey[300],
                      ),
                      Gap(12.h),
                      Text(
                        'search_for_location'.tr,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Selected location card
              if (_addressResults.isEmpty &&
                  _selectedAddress.value.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: _buildSelectedCard(theme),
                );
              }

              // Search results
              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: _addressResults.length,
                separatorBuilder: (_, __) => Gap(8.h),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _selectLocation(index),
                    child: Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.08,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: theme.colorScheme.primary,
                              size: 16.sp,
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Text(
                              _addressResults[index],
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12.sp,
                            color: Colors.grey[400],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // ── Confirm Button ──
          Obx(
            () => _selectedAddress.value.isNotEmpty
                ? Container(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 28.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _confirmLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'confirm_location'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on_rounded,
              color: theme.colorScheme.primary,
              size: 20.sp,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'selected_location'.tr,
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
                Gap(4.h),
                Text(
                  _selectedAddress.value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit_rounded,
              size: 18.sp,
              color: theme.colorScheme.primary,
            ),
            onPressed: () {
              _selectedAddress.value = '';
              _searchController.clear();
            },
          ),
        ],
      ),
    );
  }
}
