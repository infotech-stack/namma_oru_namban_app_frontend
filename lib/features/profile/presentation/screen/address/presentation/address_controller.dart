// lib/features/address/presentation/controller/address_controller.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/usecases/create_address_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/usecases/delete_address_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/usecases/get_addresses_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/address/domain/usecases/update_address_usecase.dart';
import 'package:userapp/features/profile/presentation/screen/address/presentation/widget/address_bottom_sheet.dart';

import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';
import 'package:userapp/utils/services/location_service.dart';

class AddressController extends GetxController {
  final GetAddressesUseCase _getAddressesUseCase;
  final CreateAddressUseCase _createAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final DeleteAddressUseCase _deleteAddressUseCase;
  final LocationService _locationService;

  AddressController({
    required GetAddressesUseCase getAddressesUseCase,
    required CreateAddressUseCase createAddressUseCase,
    required UpdateAddressUseCase updateAddressUseCase,
    required DeleteAddressUseCase deleteAddressUseCase,
    LocationService? locationService,
  }) : _getAddressesUseCase = getAddressesUseCase,
       _createAddressUseCase = createAddressUseCase,
       _updateAddressUseCase = updateAddressUseCase,
       _deleteAddressUseCase = deleteAddressUseCase,
       _locationService = locationService ?? LocationService();

  // ── State ──────────────────────────────────────────────────────
  final RxList<AddressEntity> addresses = <AddressEntity>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isDeleting = false.obs;
  final isLocating = false.obs;
  final errorMessage = ''.obs;

  // ── Form state ─────────────────────────────────────────────────
  final addressController = TextEditingController();
  final selectedLabel = 'home'.obs;
  final isDefault = false.obs;
  final formLat = 0.0.obs;
  final formLng = 0.0.obs;
  final hasLocation = false.obs;

  // ── Location permission state ──────────────────────────────────
  final locationPermission = LocationPermission.denied.obs;

  // ── Label options ──────────────────────────────────────────────
  final List<String> labelOptions = ['home', 'work', 'other'];

  @override
  void onInit() {
    super.onInit();
    AppLogger.info('AddressController → onInit');
    fetchAddresses();
    _checkLocationPermission();
  }

  // ── Check location permission on start ────────────────────────
  Future<void> _checkLocationPermission() async {
    locationPermission.value = await _locationService.getPermissionStatus();
    AppLogger.info(
      'AddressController → permission: ${locationPermission.value}',
    );
  }

  // ── Fetch addresses ───────────────────────────────────────────
  Future<void> fetchAddresses() async {
    isLoading.value = true;
    errorMessage.value = '';

    AppLogger.info('AddressController → fetchAddresses');

    final result = await _getAddressesUseCase();

    if (result.isSuccess && result.data != null) {
      addresses.assignAll(result.data!);
      AppLogger.info(
        'AddressController → fetchAddresses: ${addresses.length} addresses',
      );
    } else {
      errorMessage.value = result.error ?? 'failed_to_load_addresses'.tr;
      AppLogger.error(
        'AddressController → fetchAddresses: FAILED — ${errorMessage.value}',
      );
    }

    isLoading.value = false;
  }

  // ── Use current GPS location ──────────────────────────────────
  Future<void> useCurrentLocation() async {
    isLocating.value = true;

    AppLogger.info('AddressController → useCurrentLocation');

    // Check if permanently denied → open settings
    final status = await _locationService.getPermissionStatus();
    if (status == LocationPermission.deniedForever) {
      isLocating.value = false;
      _showPermissionDeniedDialog();
      return;
    }

    final result = await _locationService.getCurrentLocation();

    if (result != null) {
      addressController.text = result.address;
      formLat.value = result.lat;
      formLng.value = result.lng;
      hasLocation.value = true;
      locationPermission.value = LocationPermission.always;
      AppLogger.info(
        'AddressController → useCurrentLocation: ${result.address}',
      );
    } else {
      // Permission denied — show dialog
      final permission = await _locationService.getPermissionStatus();
      locationPermission.value = permission;

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showPermissionDeniedDialog();
      } else {
        AppSnackbar.error(
          'location_fetch_failed'.tr,
          title: 'error'.tr,
          isRaw: true,
        );
      }
    }

    isLocating.value = false;
  }

  // ── Permission denied dialog ──────────────────────────────────
  void _showPermissionDeniedDialog() {
    Get.defaultDialog(
      title: 'location_permission_title'.tr,
      middleText: 'location_permission_msg'.tr,
      textConfirm: 'open_settings'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Get.theme.colorScheme.secondary,
      onConfirm: () {
        Get.back();
        _locationService.openSettings();
      },
    );
  }

  // ── Create address ────────────────────────────────────────────
  Future<void> createAddress() async {
    final addressText = addressController.text.trim();

    if (addressText.isEmpty) {
      AppSnackbar.error('address_required'.tr, title: 'error'.tr, isRaw: true);
      return;
    }

    if (!hasLocation.value) {
      AppSnackbar.error('location_required'.tr, title: 'error'.tr, isRaw: true);
      return;
    }

    if (addresses.length >= 5) {
      AppSnackbar.error(
        'max_addresses_reached'.tr,
        title: 'error'.tr,
        isRaw: true,
      );
      return;
    }

    isSaving.value = true;
    AppLogger.info(
      'AddressController → createAddress: label=${selectedLabel.value}',
    );

    final result = await _createAddressUseCase(
      label: selectedLabel.value,
      address: addressText,
      lat: formLat.value,
      lng: formLng.value,
      isDefault: isDefault.value,
    );

    if (result.isSuccess && result.data != null) {
      addresses.insert(0, result.data!);
      // If set as default, unset others
      if (result.data!.isDefault) _syncDefaultState(result.data!.id);
      _resetForm();
      Get.back(); // close bottom sheet
      AppSnackbar.success(
        'address_created'.tr,
        title: 'success'.tr,
        isRaw: true,
      );
      AppLogger.info('AddressController → createAddress: success');
    } else {
      AppSnackbar.error(
        result.error ?? 'failed_to_create_address'.tr,
        title: 'error'.tr,
        isRaw: true,
      );
      AppLogger.error(
        'AddressController → createAddress: FAILED — ${result.error}',
      );
    }

    isSaving.value = false;
  }

  // ── Update address ────────────────────────────────────────────
  Future<void> updateAddress(AddressEntity existing) async {
    final addressText = addressController.text.trim();

    if (addressText.isEmpty) {
      AppSnackbar.error('address_required'.tr, title: 'error'.tr, isRaw: true);
      return;
    }

    isSaving.value = true;
    AppLogger.info('AddressController → updateAddress: id=${existing.id}');

    final result = await _updateAddressUseCase(
      id: existing.id,
      address: addressText,
      isDefault: isDefault.value,
    );

    if (result.isSuccess && result.data != null) {
      final index = addresses.indexWhere((a) => a.id == existing.id);
      if (index != -1) addresses[index] = result.data!;
      if (result.data!.isDefault) _syncDefaultState(result.data!.id);
      _resetForm();
      Get.back();
      AppSnackbar.success(
        'address_updated'.tr,
        title: 'success'.tr,
        isRaw: true,
      );
      AppLogger.info('AddressController → updateAddress: success');
    } else {
      AppSnackbar.error(
        result.error ?? 'failed_to_update_address'.tr,
        title: 'error'.tr,
        isRaw: true,
      );
      AppLogger.error(
        'AddressController → updateAddress: FAILED — ${result.error}',
      );
    }

    isSaving.value = false;
  }

  // ── Delete address ────────────────────────────────────────────
  Future<void> deleteAddress(AddressEntity address) async {
    isDeleting.value = true;
    AppLogger.info('AddressController → deleteAddress: id=${address.id}');

    final result = await _deleteAddressUseCase(address.id);

    if (result.isSuccess) {
      addresses.removeWhere((a) => a.id == address.id);
      AppSnackbar.success(
        'address_deleted'.tr,
        title: 'success'.tr,
        isRaw: true,
      );
      AppLogger.info('AddressController → deleteAddress: success');
    } else {
      AppSnackbar.error(
        result.error ?? 'failed_to_delete_address'.tr,
        title: 'error'.tr,
        isRaw: true,
      );
      AppLogger.error(
        'AddressController → deleteAddress: FAILED — ${result.error}',
      );
    }

    isDeleting.value = false;
  }

  // ── Show delete confirm dialog ────────────────────────────────
  void showDeleteDialog(AddressEntity address) {
    Get.defaultDialog(
      title: 'delete_address_title'.tr,
      middleText: 'delete_address_msg'.tr,
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Get.theme.colorScheme.secondary,
      buttonColor: const Color(0xFFEF4444),
      onConfirm: () {
        Get.back();
        deleteAddress(address);
      },
    );
  }

  // ── Open add bottom sheet ─────────────────────────────────────
  void openAddSheet() {
    _resetForm();
    // Auto-fetch location when opening add sheet
    _autoRequestLocation();
    Get.bottomSheet(
      const AddressBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Get.theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  // ── Auto request location when opening add form ───────────────
  Future<void> _autoRequestLocation() async {
    final status = await _locationService.getPermissionStatus();

    if (status == LocationPermission.always ||
        status == LocationPermission.whileInUse) {
      // Already granted — fetch silently
      await useCurrentLocation();
    }
    // If denied — user can manually tap "Use my location" button
  }

  // ── Open edit bottom sheet ────────────────────────────────────
  void openEditSheet(AddressEntity address) {
    // Pre-fill form
    addressController.text = address.address;
    selectedLabel.value = address.label;
    isDefault.value = address.isDefault;
    formLat.value = address.lat;
    formLng.value = address.lng;
    hasLocation.value = true;

    Get.bottomSheet(
      AddressBottomSheet(editingAddress: address),
      isScrollControlled: true,
      backgroundColor: Get.theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  // ── Set default optimistically ────────────────────────────────
  Future<void> setDefault(AddressEntity address) async {
    if (address.isDefault) return;

    AppLogger.info('AddressController → setDefault: id=${address.id}');

    // Optimistic update
    _syncDefaultState(address.id);

    final result = await _updateAddressUseCase(
      id: address.id,
      address: address.address,
      isDefault: true,
    );

    if (!result.isSuccess) {
      // Revert on failure
      AppLogger.error('AddressController → setDefault: FAILED');
      await fetchAddresses();
    }
  }

  // ── Sync default state locally ────────────────────────────────
  void _syncDefaultState(int defaultId) {
    addresses.assignAll(
      addresses
          .map(
            (a) => AddressEntity(
              id: a.id,
              userId: a.userId,
              label: a.label,
              address: a.address,
              lat: a.lat,
              lng: a.lng,
              isDefault: a.id == defaultId,
              createdAt: a.createdAt,
              updatedAt: a.updatedAt,
            ),
          )
          .toList(),
    );
  }

  // ── Reset form ────────────────────────────────────────────────
  void _resetForm() {
    addressController.clear();
    selectedLabel.value = 'home';
    isDefault.value = false;
    formLat.value = 0.0;
    formLng.value = 0.0;
    hasLocation.value = false;
  }

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }
}
