// lib/features/vehicle_details/unified/controllers/unified_vehicle_detail_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/core/logger/app_logger.dart';
import 'package:userapp/core/route/app_routes.dart';
import 'package:userapp/core/theme/app_colors.dart';
import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';
import 'package:userapp/features/home/domain/usecases/get_vehicle_detail_usecase.dart';
import 'package:userapp/features/review/driver_review/domain/entities/review_entity.dart';
import 'package:userapp/features/review/driver_review/domain/usecases/get_reviews_usecase.dart';
import 'package:userapp/features/vehicle_details/presentation/binding/vehicle_binding.dart';
import 'package:userapp/features/vehicle_details/presentation/screen/unified_vehicle_detail_screen.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_reviews_section.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_similar_list.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_specs_container.dart';
import 'package:userapp/features/vehicle_details/widget/common/vehicle_stats_row.dart';
import 'package:userapp/utils/commons/snackbar/app_snackbar.dart';
import 'package:userapp/utils/constants/app_images.dart';

class UnifiedVehicleDetailController extends GetxController {
  final GetVehicleDetailUseCase _getVehicleDetailUseCase;
  final GetReviewsUseCase _getReviewsUseCase;

  UnifiedVehicleDetailController(
    this._getVehicleDetailUseCase,
    this._getReviewsUseCase,
  );

  // State
  final vehicleId = 0.obs;
  final vehicle = Rxn<VehicleEntity>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // UI States
  final isFavourite = false.obs;
  final isReadMore = false.obs;
  final currentImageIndex = 0.obs;

  // Review state
  final reviews = <ReviewEntity>[].obs;
  final isLoadingReviews = false.obs;
  final avgRating = 0.0.obs;

  // ─── Helper: specs array-லயும் extraData-லயும் தேடு ───────────────────────
  /// API specs array-ல் [label] match பண்ணி value return பண்றது.
  /// இல்லன்னா extraData-ல தேடுது. இல்லன்னா [fallback] return பண்றது.
  String _getSpecValue(String label, {String fallback = 'N/A'}) {
    // 1️⃣ specs array-ல தேடு (API response)
    final specs = vehicle.value?.specs;
    if (specs != null) {
      for (final spec in specs) {
        if ((spec['label'] as String?) == label) {
          final val = spec['value'] as String?;
          if (val != null && val.isNotEmpty) return val;
        }
      }
    }
    // 2️⃣ extraData-ல தேடு (legacy / local)
    final fromExtra = vehicle.value?.extraData?[label];
    if (fromExtra != null && fromExtra.toString().isNotEmpty) {
      return fromExtra.toString();
    }
    return fallback;
  }

  // Computed properties
  String get name => vehicle.value?.nameKey ?? '';
  String get rating => vehicle.value?.rating ?? '0.0';
  String get fare => vehicle.value?.fare ?? '0';
  String get fareUnit => _getFareUnit();
  String get tripsCompleted => vehicle.value?.driverTrips.toString() ?? '0';
  String get distance => '3.2';
  String get eta => vehicle.value?.eta ?? '15';
  String get capacity => vehicle.value?.capacity ?? '';
  String get registrationNo => vehicle.value?.registrationNo ?? '';
  String get driverName => vehicle.value?.driverName ?? '';
  String? get driverPhoto => vehicle.value?.driverPhoto;
  bool get isOnline => vehicle.value?.isOnline ?? false;

  // Type-specific getters
  String get seatingCapacity =>
      vehicle.value?.extraData?['seating_capacity'] ??
      vehicle.value?.capacity ??
      'N/A';
  String get seatType => _getSpecValue('seat_type', fallback: 'Standard');
  String get fuelType => vehicle.value?.fuelType ?? 'N/A';
  String get transmission => _getSpecValue('transmission', fallback: 'Manual');
  String get acAvailable => _getSpecValue('ac_available');
  String get musicSystem => _getSpecValue('music_system', fallback: 'Yes');
  String get manufacturer => vehicle.value?.make ?? 'N/A';
  String get model => vehicle.value?.nameKey ?? '';

  // Bus specific
  String get busCategory => _getSpecValue('bus_category', fallback: 'Standard');
  String get chargingPoints =>
      _getSpecValue('charging_points', fallback: 'Yes');
  String get entertainment =>
      _getSpecValue('entertainment', fallback: 'LED TV');
  String get toilet => _getSpecValue('toilet', fallback: 'No');
  // List<String> get amenities => _getListValue('amenities');

  // JCB specific
  String get condition => vehicle.value?.condition ?? 'Good';
  String get bucketType => _getSpecValue('bucket_type', fallback: 'Standard');
  String get machineAge => _getSpecValue('machine_age', fallback: '2 years');
  // List<String> get workingAreas => _getListValue('working_areas');

  // Heavy Lorry specific
  String get bodyType => _getSpecValue('body_type', fallback: 'Open');
  String get loadCapacity => vehicle.value?.capacity ?? 'N/A';
  String get loadingCharge => vehicle.value?.loadingCharge?.toString() ?? 'N/A';
  String get unloadingCharge =>
      vehicle.value?.unloadingCharge?.toString() ?? 'N/A';
  List<String> get loadTypes => _getListValue('load_types');

  // Tata Ace specific
  List<String> get usageTypes => _getListValue('usage_types');

  // Tractor specific
  String get tractorCategory =>
      _getSpecValue('tractor_category', fallback: 'General');

  /// attachment — "rotavator,plough" போன்ற comma-separated string.
  /// specs array-ல் இருந்தாலும் / extraData-ல் இருந்தாலும் return பண்றோம்.
  String get attachment => _getSpecValue('attachment', fallback: 'N/A');

  String get hp => _getSpecValue('hp', fallback: 'N/A');
  String get minHours => vehicle.value?.minHours != null
      ? '${vehicle.value!.minHours} hrs'
      : 'N/A';

  // Agri Equipment specific
  String get equipmentType =>
      _getSpecValue('equipment_type', fallback: 'Equipment');
  String get modelName =>
      _getSpecValue('model', fallback: vehicle.value?.nameKey ?? '');
  String get availableFrom =>
      _getSpecValue('available_from', fallback: '08:00 AM');
  String get availableTo => _getSpecValue('available_to', fallback: '06:00 PM');
  String get minBookingHours => vehicle.value?.minHours != null
      ? '${vehicle.value!.minHours} hrs'
      : '4 hrs';
  List<String> get suitableFor => _getListValue('suitable_for');

  bool get canBook => vehicle.value?.canBook ?? true;
  bool get isBusy => vehicle.value?.isDriverBusy ?? false;
  String get busyReason => vehicle.value?.busyReason ?? 'driver_unavailable'.tr;

  // ─── List helper ─────────────────────────────────────────────────────────────
  /// specs array-ல் comma-separated value-ஐ List-ஆ return பண்றது.
  /// இல்லன்னா extraData-ல JSON array-ஆ தேடுது.
  List<String> _getListValue(String key) {
    // 1️⃣ specs array-ல தேடு
    final specs = vehicle.value?.specs;
    if (specs != null) {
      for (final spec in specs) {
        if ((spec['label'] as String?) == key) {
          final val = spec['value'] as String?;
          if (val != null && val.isNotEmpty) {
            // comma-separated ஆ இருந்தா split பண்றோம்
            return val
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
          }
        }
      }
    }
    // 2️⃣ extraData-ல JSON array-ஆ தேடு
    final extraData = vehicle.value?.extraData;
    if (extraData != null && extraData[key] != null) {
      return List<String>.from(extraData[key]);
    }
    return [];
  }

  List<String> get amenities {
    return vehicle.value?.amenities ?? [];
  }

  List<String> get workingAreas {
    return vehicle.value?.working_areas ?? [];
  }

  // Collections
  List<StatItem> get stats => _buildStats();
  List<SpecItem> get specs => _buildSpecs();
  List<String> get images => _buildImages();
  List<SimilarVehicleItem> get similarVehicles => _buildSimilarVehicles();
  //List<ReviewData> get reviews => _buildReviews();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      if (args['id'] != null) {
        vehicleId.value = args['id'];
        fetchVehicleDetail();
        fetchReviews();
      } else if (args['vehicle'] != null) {
        vehicle.value = args['vehicle'] as VehicleEntity;
        vehicleId.value = vehicle.value!.id;
        fetchVehicleDetail();
        fetchReviews();
      }
    }
  }

  Future<void> fetchReviews() async {
    if (vehicleId.value == 0) return;

    isLoadingReviews.value = true;

    final res = await _getReviewsUseCase(vehicleId.value);

    if (res.isSuccess && res.data != null) {
      reviews.assignAll(res.data!.reviews);
      avgRating.value = res.data!.avgRating;
    }

    isLoadingReviews.value = false;
  }

  Future<void> fetchVehicleDetail() async {
    if (vehicleId.value == 0) return;

    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getVehicleDetailUseCase(vehicleId.value);

    if (result.isSuccess && result.data != null) {
      vehicle.value = result.data;
      AppLogger.info(
        'UnifiedVehicleDetail: Loaded vehicle ${vehicle.value!.nameKey}',
      );
    } else {
      errorMessage.value = result.error ?? 'Failed to load vehicle details';
      AppLogger.error('UnifiedVehicleDetail: Failed to load - ${result.error}');
    }

    isLoading.value = false;
  }

  List<ReviewData> get reviewList {
    return reviews.map((r) {
      return ReviewData(
        name: r.name,
        avatar: r.avatar,
        rating: r.rating,
        comment: r.comment,
        date: r.date,
      );
    }).toList();
  }

  String _getFareUnit() {
    final pricingModel = vehicle.value?.pricingModel;
    switch (pricingModel) {
      case 'per_km':
        return '/km';
      case 'per_hour':
        return '/hr';
      case 'per_day':
        return '/day';
      case 'per_trip':
        return '/trip';
      case 'per_load':
        return '/load';
      case 'per_acre':
        return '/acre';
      default:
        return '/km';
    }
  }

  List<StatItem> _buildStats() {
    final type = vehicle.value?.categorySlug ?? 'car';
    final statsList = <StatItem>[];

    switch (type) {
      case 'car':
        String seatValue = seatingCapacity
            .replaceAll(' Seats', '')
            .replaceAll('+', '');

        statsList.add(
          StatItem(
            icon: Icons.event_seat_rounded,
            labelKey: 'seating',
            value: seatValue,
            color: AppTheme.primaryColor,
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.speed_rounded,
            labelKey: 'trans',
            value: transmission.length > 8
                ? transmission.substring(0, 6)
                : transmission,
            color: const Color(0xFF1E88E5),
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.local_gas_station_rounded,
            labelKey: 'fuel',
            value: fuelType.length > 6 ? fuelType.substring(0, 4) : fuelType,
            color: const Color(0xFFE53935),
          ),
        );
        break;

      case 'bus':
      case 'mini_bus':
        String seatValue = seatingCapacity
            .replaceAll(' Seats', '')
            .replaceAll(' Passengers', '');

        statsList.add(
          StatItem(
            icon: Icons.event_seat_rounded,
            labelKey: 'seats',
            value: seatValue,
            color: AppTheme.primaryColor,
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.ac_unit_rounded,
            labelKey: 'ac',
            value: acAvailable == 'Yes'
                ? 'AC'
                : acAvailable == 'No'
                ? 'Non AC'
                : 'N/A',
            color: const Color(0xFF1E88E5),
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.speed_rounded,
            labelKey: 'type',
            value: (busCategory.tr.length > 10)
                ? busCategory.tr.substring(0, 8)
                : busCategory.tr,
            color: const Color(0xFFE53935),
          ),
        );
        break;

      case 'jcb':
        statsList.add(
          StatItem(
            icon: Icons.speed_rounded,
            labelKey: 'cap',
            value: capacity.isNotEmpty ? capacity : "N/A",
            color: AppTheme.primaryColor,
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.local_gas_station_rounded,
            labelKey: 'fuel_type',
            value: fuelType.length > 6 ? fuelType.substring(0, 4) : fuelType,
            color: const Color(0xFF1E88E5),
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.build_rounded,
            labelKey: 'cond',
            value: condition.length > 6 ? condition.substring(0, 5) : condition,
            color: const Color(0xFFE53935),
          ),
        );
        break;

      case 'heavy_lorry':
      case 'tata_ace':
        statsList.add(
          StatItem(
            icon: Icons.local_shipping_rounded,
            labelKey: 'type',
            value: bodyType.length > 8 ? bodyType.substring(0, 6) : bodyType,
            color: AppTheme.primaryColor,
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.scale_rounded,
            labelKey: 'load',
            value: loadCapacity.replaceAll(' Ton', 'T').replaceAll(' kg', 'kg'),
            color: const Color(0xFF1E88E5),
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.local_gas_station_rounded,
            labelKey: 'fuel',
            value: fuelType.length > 6 ? fuelType.substring(0, 4) : fuelType,
            color: const Color(0xFFE53935),
          ),
        );
        break;

      case 'tractor':
        // hp - capacity field-ல இருக்கு (e.g. "45 HP")
        final hpDisplay = capacity.replaceAll(' HP', '').replaceAll(' hp', '');
        statsList.add(
          StatItem(
            icon: Icons.speed_rounded,
            labelKey: 'hp',
            value: hpDisplay.isNotEmpty ? hpDisplay : hp,
            color: AppTheme.primaryColor,
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.agriculture_rounded,
            labelKey: 'type',
            value: tractorCategory.length > 8
                ? tractorCategory.substring(0, 6)
                : tractorCategory,
            color: const Color(0xFF1E88E5),
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.local_gas_station_rounded,
            labelKey: 'fuel',
            value: fuelType.length > 6 ? fuelType.substring(0, 4) : fuelType,
            color: const Color(0xFFE53935),
          ),
        );
        break;

      case 'agri_equipment':
        statsList.add(
          StatItem(
            icon: Icons.speed_rounded,
            labelKey: 'cap',
            value: capacity
                .replaceAll(' acres/hr', '')
                .replaceAll(' acres', ''),
            color: AppTheme.primaryColor,
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.local_gas_station_rounded,
            labelKey: 'fuel',
            value: fuelType.length > 6 ? fuelType.substring(0, 4) : fuelType,
            color: const Color(0xFF1E88E5),
          ),
        );
        statsList.add(
          StatItem(
            icon: Icons.build_rounded,
            labelKey: 'cond',
            value: condition.length > 6 ? condition.substring(0, 5) : condition,
            color: const Color(0xFFE53935),
          ),
        );
        break;
    }

    return statsList;
  }

  List<SpecItem> _buildSpecs() {
    final specsList = <SpecItem>[];

    // specs from API இருந்தா directly use பண்றோம்
    if (vehicle.value?.specs != null && vehicle.value!.specs!.isNotEmpty) {
      for (var spec in vehicle.value!.specs!) {
        specsList.add(
          SpecItem(
            labelKey: spec['label'] as String? ?? '',
            value: spec['value'] as String? ?? '',
          ),
        );
      }
      return specsList;
    }

    // Fallback: build specs from data
    final type = vehicle.value?.categorySlug ?? 'car';

    _addSpec(specsList, 'fuel_type', fuelType);
    _addSpec(specsList, 'condition', condition);
    _addSpec(specsList, 'pricing_model', vehicle.value?.pricingModel ?? '');
    _addSpec(
      specsList,
      'base_price',
      vehicle.value?.basePrice != null ? '₹${vehicle.value!.basePrice}' : '',
    );
    _addSpec(
      specsList,
      'extra_km_charge',
      vehicle.value?.extraKmCharge != null
          ? '₹${vehicle.value!.extraKmCharge}/km'
          : '',
    );
    _addSpec(
      specsList,
      'extra_hour_charge',
      vehicle.value?.extraHourCharge != null
          ? '₹${vehicle.value!.extraHourCharge}/hr'
          : '',
    );
    _addSpec(
      specsList,
      'min_km',
      vehicle.value?.minKm != null ? '${vehicle.value!.minKm} km' : '',
    );
    _addSpec(
      specsList,
      'min_hours',
      vehicle.value?.minHours != null ? '${vehicle.value!.minHours} hrs' : '',
    );
    _addSpec(
      specsList,
      'driver_bata',
      vehicle.value?.driverBata != null ? '₹${vehicle.value!.driverBata}' : '',
    );
    _addSpec(
      specsList,
      'operator_bata',
      vehicle.value?.operatorBata != null
          ? '₹${vehicle.value!.operatorBata}'
          : '',
    );

    switch (type) {
      case 'car':
        _addSpec(specsList, 'seating_capacity', seatingCapacity);
        _addSpec(specsList, 'seat_type', seatType);
        _addSpec(specsList, 'transmission', transmission);
        _addSpec(specsList, 'ac_available', acAvailable);
        _addSpec(specsList, 'music_system', musicSystem);
        _addSpec(specsList, 'manufacturer', manufacturer);
        _addSpec(specsList, 'model', model);
        break;
      case 'bus':
      case 'mini_bus':
        _addSpec(specsList, 'bus_category', busCategory);
        _addSpec(specsList, 'seating_capacity', seatingCapacity);
        _addSpec(specsList, 'seat_type', seatType);
        _addSpec(specsList, 'ac_available', acAvailable);
        _addSpec(specsList, 'charging_points', chargingPoints);
        _addSpec(specsList, 'entertainment', entertainment);
        _addSpec(specsList, 'toilet', toilet);
        break;
      case 'jcb':
        _addSpec(specsList, 'bucket_type', bucketType);
        _addSpec(specsList, 'machine_age', machineAge);
        _addSpec(specsList, 'working_areas', workingAreas.join(', '));
        break;
      case 'heavy_lorry':
        _addSpec(specsList, 'body_type', bodyType);
        _addSpec(specsList, 'load_capacity', loadCapacity);
        _addSpec(
          specsList,
          'loading_charge',
          loadingCharge != 'N/A' ? '₹$loadingCharge' : '',
        );
        _addSpec(
          specsList,
          'unloading_charge',
          unloadingCharge != 'N/A' ? '₹$unloadingCharge' : '',
        );
        _addSpec(specsList, 'load_types', loadTypes.join(', '));
        break;
      case 'tata_ace':
        _addSpec(specsList, 'body_type', bodyType);
        _addSpec(specsList, 'payload', loadCapacity);
        _addSpec(specsList, 'usage_types', usageTypes.join(', '));
        break;
      case 'tractor':
        _addSpec(specsList, 'tractor_category', tractorCategory);
        _addSpec(specsList, 'attachment', attachment);
        _addSpec(specsList, 'hp', hp);
        _addSpec(specsList, 'min_hours', minHours);
        break;
      case 'agri_equipment':
        _addSpec(specsList, 'equipment_type', equipmentType);
        _addSpec(specsList, 'model_name', modelName);
        _addSpec(specsList, 'capacity', capacity);
        _addSpec(specsList, 'available_from', availableFrom);
        _addSpec(specsList, 'available_to', availableTo);
        _addSpec(specsList, 'min_booking', minBookingHours);
        break;
    }

    return specsList;
  }

  void _addSpec(List<SpecItem> list, String labelKey, String value) {
    if (value.isNotEmpty && value != 'N/A' && value != 'null') {
      list.add(SpecItem(labelKey: labelKey, value: value));
    }
  }

  List<String> _buildImages() {
    if (vehicle.value?.vehiclePhotos != null &&
        vehicle.value!.vehiclePhotos!.isNotEmpty) {
      return vehicle.value!.vehiclePhotos!;
    }
    if (vehicle.value?.imagePath.isNotEmpty == true) {
      return [vehicle.value!.imagePath];
    }
    return [_getDefaultImage()];
  }

  String _getDefaultImage() {
    final type = vehicle.value?.categorySlug ?? 'car';
    switch (type) {
      case 'car':
        return AppAssetsConstants.car;
      case 'bus':
      case 'mini_bus':
        return AppAssetsConstants.bus;
      case 'jcb':
        return AppAssetsConstants.jcb;
      case 'heavy_lorry':
        return AppAssetsConstants.lorry;
      case 'tata_ace':
        return AppAssetsConstants.tataAce;
      case 'tractor':
        return AppAssetsConstants.tractor;
      case 'agri_equipment':
        return AppAssetsConstants.agri1;
      default:
        return AppAssetsConstants.car;
    }
  }

  IconData _getIconForCategory(String categoryKey) {
    switch (categoryKey) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'bus':
        return Icons.directions_bus_rounded;
      case 'jcb':
        return Icons.construction_rounded;
      case 'lorry':
      case 'heavy_lorry':
        return Icons.local_shipping_rounded;
      case 'tata_ace':
        return Icons.local_shipping_rounded;
      case 'tractor':
        return Icons.agriculture_rounded;
      case 'agri':
      case 'agri_equipment':
        return Icons.grass_rounded;
      default:
        return Icons.directions_car_rounded;
    }
  }

  List<SimilarVehicleItem> _buildSimilarVehicles() {
    final similar = <SimilarVehicleItem>[];

    if (vehicle.value?.similarVehicles != null &&
        vehicle.value!.similarVehicles!.isNotEmpty) {
      for (var v in vehicle.value!.similarVehicles!) {
        similar.add(
          SimilarVehicleItem(
            name: v['name'] as String? ?? '',
            fare: v['fare'] as String? ?? '',
            rating: v['rating'] as String? ?? '0.0',
            icon: _getIconForCategory(v['categoryKey'] as String? ?? 'car'),
            id: v['id'] as int? ?? 0,
            imagePath: v['imagePath'] as String?,
            categoryKey: v['categoryKey'] as String? ?? 'car',
            categorySlug: v['categorySlug'] as String? ?? 'car',
          ),
        );
      }
    }
    return similar;
  }

  /*List<ReviewData> _buildReviews() {
    return [
      ReviewData(
        name: 'Arun Kumar',
        avatar: 'AK',
        rating: 2,
        comment:
            'Excellent service! Vehicle was in perfect condition. Driver was very professional and punctual.',
        date: '2 days ago',
      ),
      ReviewData(
        name: 'Priya Sharma',
        avatar: 'PS',
        rating: 1,
        comment:
            'Good experience overall. Vehicle was clean and well maintained.',
        date: '1 week ago',
      ),
      ReviewData(
        name: 'Rajesh M',
        avatar: 'RM',
        rating: 1,
        comment: 'Best service! Highly recommended.',
        date: '2 weeks ago',
      ),
    ];
  }*/

  // UI Actions
  void toggleFavourite() => isFavourite.value = !isFavourite.value;
  void toggleReadMore() => isReadMore.value = !isReadMore.value;
  void onPageChanged(int index) => currentImageIndex.value = index;

  void onBookNow() {
    if (!canBook) {
      AppSnackbar.warning(
        busyReason,
        title: 'driver_busy_title'.tr,
        isRaw: true,
      );
      return;
    }
    AppLogger.info('UnifiedVehicleDetailController: Booking vehicle: $name');

    // ✅ Debug - Check what's in vehicle.value
    AppLogger.info('=== VEHICLE DATA DEBUG ===');
    AppLogger.info('vehicle.value exists: ${vehicle.value != null}');

    if (vehicle.value != null) {
      AppLogger.info(
        'vehicle.value?.driverName: "${vehicle.value?.driverName}"',
      );
      AppLogger.info(
        'vehicle.value?.driverPhoto: "${vehicle.value?.driverPhoto}"',
      );
      AppLogger.info('vehicle.value?.nameKey: "${vehicle.value?.nameKey}"');
      AppLogger.info(
        'vehicle.value?.registrationNo: "${vehicle.value?.registrationNo}"',
      );

      // Print all keys from vehicle.value
      //AppLogger.info('All vehicle data: ${vehicle.value?.}');
    }

    double farePerKm = 0.0;
    if (fare.isNotEmpty) {
      farePerKm =
          double.tryParse(
            fare.replaceAll('₹', '').replaceAll('/km', '').trim(),
          ) ??
          0.0;
    }

    Get.toNamed(
      Routes.unifiedBooking,
      arguments: {
        'id': vehicle.value?.id,
        'vehicleId': vehicle.value?.id,
        'vehicleName': name,
        'name': name,
        'imagePath': vehicle.value?.imagePath,
        'vehicleNumber': registrationNo,
        'driverName': driverName,
        'driverRating': double.tryParse(rating) ?? 4.5,
        'vehicleType': vehicle.value?.categorySlug ?? 'car',
        'categoryKey': vehicle.value?.categorySlug ?? 'car',
        'basePrice': vehicle.value?.basePrice ?? 0.0,
        'fare': fare,
        'farePerKm': farePerKm,
        'extraKmCharge': vehicle.value?.extraKmCharge ?? 0.0,
        'extraHourCharge': vehicle.value?.extraHourCharge ?? 0.0,
        'driverBata': vehicle.value?.driverBata ?? 0.0,
        'operatorBata': vehicle.value?.operatorBata ?? 0.0,
        'loadingCharge': vehicle.value?.loadingCharge ?? 0.0,
        'unloadingCharge': vehicle.value?.unloadingCharge ?? 0.0,
        'seatingCapacity': seatingCapacity,
        'busCategory': busCategory,
        'loadCapacity': loadCapacity,
        'bodyType': bodyType,
        'bucketType': bucketType,
        'fuelType': fuelType,
        'horsePower': hp,
        'attachment': attachment,
        'equipmentType': equipmentType,
        'capacity': capacity,
        'distance': double.tryParse(distance) ?? 10.0,
      },
    );
  }

  Map<String, dynamic> getBookingArguments() => {
    'vehicleType': vehicle.value?.categorySlug ?? 'car',
    'vehicleName': name,
    'vehicleNumber': registrationNo,
    'basePrice': vehicle.value?.basePrice ?? 0.0,
    'extraKmCharge': vehicle.value?.extraKmCharge ?? 0.0,
    'extraHourCharge': vehicle.value?.extraHourCharge ?? 0.0,
    'driverBata': vehicle.value?.driverBata ?? 0.0,
    'operatorBata': vehicle.value?.operatorBata ?? 0.0,
    'fare': fare,
    'imagePath': vehicle.value?.imagePath,
    'seatingCapacity': seatingCapacity,
    'acAvailable': acAvailable,
    'fuelType': fuelType,
    'capacity': capacity,
    'distance': distance,
    'eta': eta,
    'driverName': driverName,
    'driverPhoto': driverPhoto,
  };

  // Add this flag at the top of the controller
  bool _isNavigating = false;

  void onSimilarVehicleTap(SimilarVehicleItem similarVehicle) {
    if (_isNavigating) return;
    _isNavigating = true;

    AppLogger.info(
      'Tapping similar vehicle - id=${similarVehicle.id}, name=${similarVehicle.name}',
    );

    // Delete old controller first, then navigate
    Get.delete<UnifiedVehicleDetailController>(force: true);

    Get.toNamed(
      Routes.unifiedVehicleDetail,
      arguments: {'id': similarVehicle.id},
      preventDuplicates: false,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      _isNavigating = false;
    });
  }

  @override
  void onClose() {
    AppLogger.info('UnifiedVehicleDetailController: Closed');
    super.onClose();
  }
}
