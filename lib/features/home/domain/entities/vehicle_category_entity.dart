// lib/features/home/domain/entities/vehicle_category_entity.dart
// ════════════════════════════════════════════════════════════════
//  VEHICLE CATEGORY ENTITY — Domain Layer
// ════════════════════════════════════════════════════════════════

class VehicleCategoryEntity {
  final String filterKey;
  final String slug;
  final String name;
  final String? imageUrl;
  final int vehicleCount;

  const VehicleCategoryEntity({
    required this.filterKey,
    required this.slug,
    required this.name,
    this.imageUrl,
    required this.vehicleCount,
  });
}

// lib/features/home/domain/entities/vehicle_entity.dart
// ════════════════════════════════════════════════════════════════
//  VEHICLE ENTITY — Domain Layer
// ════════════════════════════════════════════════════════════════

// lib/features/home/domain/entities/vehicle_entity.dart
// Add detailed fields for the detail screen

class VehicleEntity {
  final int id;
  final String nameKey;
  final String rating;
  final String capacity;
  final String fare;
  final String eta;
  final String categoryKey;
  final String imagePath;
  final String? registrationNo;
  final String driverName;
  final String? driverPhone;
  final String? driverPhoto;
  final int driverTrips;
  final bool isOnline;
  final String? make;
  final String categorySlug;
  final String categoryName;
  final bool? isFavorited;

  // Detailed fields from /vehicles/:id API
  final String? description;
  final String? fuelType;
  final String? condition;
  final String? pricingModel;
  final double? basePrice;
  final double? extraKmCharge;
  final double? extraHourCharge;
  final double? driverBata;
  final double? operatorBata;
  final double? loadingCharge;
  final double? unloadingCharge;
  final int? minKm;
  final int? minHours;
  final String? insuranceExpiry;
  final Map<String, dynamic>? extraData;
  final List<String>? vehiclePhotos;
  final List<Map<String, dynamic>>? specs;
  final List<Map<String, dynamic>>? similarVehicles;
  final Map<String, dynamic>? driverDetails;
  final List<String>? amenities;
  final List<String>? working_areas;
  // NEW: Driver availability status
  final DriverAvailabilityEntity? driverAvailability;
  final bool isAvailable;

  const VehicleEntity({
    required this.id,
    required this.nameKey,
    required this.rating,
    required this.capacity,
    required this.fare,
    required this.eta,
    required this.categoryKey,
    required this.imagePath,
    this.registrationNo,
    required this.driverName,
    this.driverPhoto,
    required this.driverTrips,
    required this.isOnline,
    this.make,
    required this.categorySlug,
    required this.categoryName,
    this.description,
    this.fuelType,
    this.condition,
    this.pricingModel,
    this.basePrice,
    this.extraKmCharge,
    this.extraHourCharge,
    this.driverBata,
    this.operatorBata,
    this.loadingCharge,
    this.unloadingCharge,
    this.minKm,
    this.minHours,
    this.insuranceExpiry,
    this.extraData,
    this.vehiclePhotos,
    this.specs,
    this.similarVehicles,
    this.driverDetails,
    this.amenities,
    this.working_areas,
    this.driverPhone,
    this.driverAvailability,
    this.isAvailable = true,
    this.isFavorited = false,
  });
  // Helper getters for UI
  // bool get canBook => driverAvailability?.canBook ?? isAvailable;
  bool get canBook => driverAvailability?.canBook ?? (isOnline && isAvailable);
  bool get isDriverBusy => driverAvailability?.isBusy ?? false;
  String? get busyReason => driverAvailability?.busyReason;
  String? get estimatedFreeTime => driverAvailability?.estimatedFreeTime;

  // Copy with method for updating with detailed data
  VehicleEntity copyWith({
    int? id,
    String? nameKey,
    String? rating,
    String? capacity,
    String? fare,
    String? eta,
    String? categoryKey,
    String? imagePath,
    String? registrationNo,
    String? driverName,
    String? driverPhoto,
    String? driverPhone,
    int? driverTrips,
    bool? isOnline,
    String? make,
    String? categorySlug,
    String? categoryName,
    String? description,
    String? fuelType,
    String? condition,
    String? pricingModel,
    double? basePrice,
    double? extraKmCharge,
    double? extraHourCharge,
    double? driverBata,
    double? operatorBata,
    double? loadingCharge,
    double? unloadingCharge,
    int? minKm,
    int? minHours,
    String? insuranceExpiry,
    Map<String, dynamic>? extraData,
    List<String>? vehiclePhotos,
    List<Map<String, dynamic>>? specs,
    List<Map<String, dynamic>>? similarVehicles,
    Map<String, dynamic>? driverDetails,
    List<String>? amenities,
    List<String>? working_areas,
    DriverAvailabilityEntity? driverAvailability,
    bool? isAvailable,
    bool? isFavorited,
  }) {
    return VehicleEntity(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      rating: rating ?? this.rating,
      capacity: capacity ?? this.capacity,
      fare: fare ?? this.fare,
      eta: eta ?? this.eta,
      categoryKey: categoryKey ?? this.categoryKey,
      imagePath: imagePath ?? this.imagePath,
      registrationNo: registrationNo ?? this.registrationNo,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      driverPhoto: driverPhoto ?? this.driverPhoto,
      driverTrips: driverTrips ?? this.driverTrips,
      isOnline: isOnline ?? this.isOnline,
      make: make ?? this.make,
      categorySlug: categorySlug ?? this.categorySlug,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      fuelType: fuelType ?? this.fuelType,
      condition: condition ?? this.condition,
      pricingModel: pricingModel ?? this.pricingModel,
      basePrice: basePrice ?? this.basePrice,
      extraKmCharge: extraKmCharge ?? this.extraKmCharge,
      extraHourCharge: extraHourCharge ?? this.extraHourCharge,
      driverBata: driverBata ?? this.driverBata,
      operatorBata: operatorBata ?? this.operatorBata,
      loadingCharge: loadingCharge ?? this.loadingCharge,
      unloadingCharge: unloadingCharge ?? this.unloadingCharge,
      minKm: minKm ?? this.minKm,
      minHours: minHours ?? this.minHours,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      extraData: extraData ?? this.extraData,
      vehiclePhotos: vehiclePhotos ?? this.vehiclePhotos,
      specs: specs ?? this.specs,
      similarVehicles: similarVehicles ?? this.similarVehicles,
      driverDetails: driverDetails ?? this.driverDetails,
      amenities: amenities ?? this.amenities,
      working_areas: working_areas ?? this.working_areas,
      driverAvailability: driverAvailability ?? this.driverAvailability,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
// lib/features/home/domain/entities/vehicles_response_entity.dart
// ════════════════════════════════════════════════════════════════
//  VEHICLES RESPONSE ENTITY — Domain Layer
// ════════════════════════════════════════════════════════════════

class VehiclesResponseEntity {
  final List<VehicleEntity> vehicles;
  final int total;
  final String filter;
  final int limit;
  final int offset;

  const VehiclesResponseEntity({
    required this.vehicles,
    required this.total,
    required this.filter,
    required this.limit,
    required this.offset,
  });
}

class DriverAvailabilityEntity {
  final bool isBusy;
  final String? busyReason;
  final String? estimatedFreeTime;
  final String? bookingStatus;
  final bool canBook;

  const DriverAvailabilityEntity({
    required this.isBusy,
    this.busyReason,
    this.estimatedFreeTime,
    this.bookingStatus,
    required this.canBook,
  });

  factory DriverAvailabilityEntity.fromJson(Map<String, dynamic> json) {
    return DriverAvailabilityEntity(
      isBusy: json['isBusy'] ?? false,
      busyReason: json['busyReason'],
      estimatedFreeTime: json['estimatedFreeTime'],
      bookingStatus: json['bookingStatus'],
      canBook: json['canBook'] ?? false,
    );
  }
}
