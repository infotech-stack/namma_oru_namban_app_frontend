// lib/features/home/data/models/vehicle_category_model.dart
// ════════════════════════════════════════════════════════════════
//  VEHICLE CATEGORY MODEL — Data Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/features/home/domain/entities/vehicle_category_entity.dart';

class VehicleCategoryModel {
  final String filterKey;
  final String slug;
  final String name;
  final String? imageUrl;
  final int vehicleCount;

  const VehicleCategoryModel({
    required this.filterKey,
    required this.slug,
    required this.name,
    this.imageUrl,
    required this.vehicleCount,
  });

  factory VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    // Safe parsing with type checking
    return VehicleCategoryModel(
      filterKey: _parseString(json['filterKey']),
      slug: _parseString(json['slug']),
      name: _parseString(json['name']),
      imageUrl: _parseNullableString(json['imageUrl']),
      vehicleCount: _parseInt(json['vehicleCount']),
    );
  }

  // Parse from API response (with data wrapper)
  factory VehicleCategoryModel.fromApiResponse(Map<String, dynamic> response) {
    final data = response['data'] as List? ?? [];
    // This is for list parsing - should be used in datasource
    throw UnimplementedError('Use fromJson for individual items');
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static String? _parseNullableString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  Map<String, dynamic> toJson() => {
    'filterKey': filterKey,
    'slug': slug,
    'name': name,
    'imageUrl': imageUrl,
    'vehicleCount': vehicleCount,
  };

  VehicleCategoryEntity toEntity() => VehicleCategoryEntity(
    filterKey: filterKey,
    slug: slug,
    name: name,
    imageUrl: imageUrl,
    vehicleCount: vehicleCount,
  );
}

// lib/features/home/data/models/vehicle_model.dart
// ════════════════════════════════════════════════════════════════
//  VEHICLE MODEL — Data Layer
// ════════════════════════════════════════════════════════════════
// lib/features/home/data/models/vehicle_model.dart
// ════════════════════════════════════════════════════════════════
//  VEHICLE MODEL — Data Layer  (safe type parsing)
// ════════════════════════════════════════════════════════════════

class VehicleModel {
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
  final String? driverPhoto;
  final int driverTrips;
  final bool isOnline;
  final String? make;
  final String categorySlug;
  final String categoryName;

  // Detailed fields
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
  VehicleModel({
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
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    // Parse specs if available
    List<Map<String, dynamic>>? specsList;
    if (json['specs'] != null) {
      specsList = (json['specs'] as List).map((spec) {
        return {
          'label': spec['label'] as String? ?? '',
          'value': spec['value'] as String? ?? '',
        };
      }).toList();
    }

    // Parse similar vehicles if available
    List<Map<String, dynamic>>? similarList;
    if (json['similarVehicles'] != null) {
      similarList = (json['similarVehicles'] as List).map((v) {
        return {
          'id': v['id'],
          'name': v['name'],
          'fare': v['fare'],
          'rating': v['rating'],
          'categoryKey': v['categoryKey'],
          'imagePath': v['imagePath'],
        };
      }).toList();
    }

    // Parse vehicle photos — support both key names
    List<String>? photos;
    if (json['vehicleImages'] != null) {
      photos = (json['vehicleImages'] as List)
          .map((p) => p.toString())
          .toList();
    } else if (json['vehiclePhotos'] != null) {
      photos = (json['vehiclePhotos'] as List)
          .map((p) => p.toString())
          .toList();
    }
    final driverData = json['driver'] as Map<String, dynamic>?;

    String driverName = '';
    String? driverPhoto;
    int driverTrips = 0;
    bool isOnline = false;

    if (driverData != null) {
      driverName = _parseString(driverData['name'] ?? driverData['driverName']);
      driverPhoto = _parseNullableString(
        driverData['photo'] ?? driverData['driverPhoto'],
      );
      driverTrips = _parseInt(
        driverData['totalTrips'] ?? driverData['driverTrips'],
      );
      isOnline = _parseBool(driverData['isOnline'] ?? false);
    }

    // Fallback: If no nested driver, try root-level fields
    if (driverName.isEmpty) {
      driverName = _parseString(json['driverName']);
    }
    if (driverPhoto == null || driverPhoto!.isEmpty) {
      driverPhoto = _parseNullableString(json['driverPhoto']);
    }
    if (driverTrips == 0) {
      driverTrips = _parseInt(json['driverTrips'] ?? json['tripsCompleted']);
    }
    if (!isOnline) {
      isOnline = _parseBool(json['isOnline']);
    }
    return VehicleModel(
      id: _parseInt(json['id']),
      nameKey: _parseString(
        json['nameKey'] ?? json['name'],
      ), // ✅ API sends 'nameKey'
      rating: _parseString(json['rating']),
      capacity: _parseString(json['capacity']),
      fare: _parseString(json['fare']),
      eta: _parseString(json['eta']),
      categoryKey: _parseString(json['categoryKey']),
      imagePath: _parseString(json['imagePath']),
      registrationNo: _parseNullableString(json['registrationNo']),
      // driverName: _parseString(json['driverName']),
      // driverPhoto: _parseNullableString(json['driverPhoto']),
      // // ✅ API sends 'driverTrips' directly (not 'tripsCompleted')
      // driverTrips: _parseInt(json['driverTrips'] ?? json['tripsCompleted']),
      // isOnline: _parseBool(json['isOnline']),
      driverName: driverName,
      driverPhoto: driverPhoto,
      driverTrips: driverTrips,
      isOnline: isOnline,
      make: _parseNullableString(json['make']),
      categorySlug: _parseString(json['categorySlug']),
      categoryName: _parseString(json['categoryName']),
      description: _parseNullableString(json['description']),
      fuelType: _parseNullableString(json['fuelType']),
      condition: _parseNullableString(json['condition']),
      pricingModel: _parseNullableString(json['pricingModel']),
      // ── All numeric fields: safe parse handles String/int/double ──
      basePrice: _parseDouble(json['basePrice']),
      extraKmCharge: _parseDouble(json['extraKmCharge']),
      extraHourCharge: _parseDouble(json['extraHourCharge']),
      driverBata: _parseDouble(json['driverBata']),
      operatorBata: _parseDouble(json['operatorBata']),
      loadingCharge: _parseDouble(json['loadingCharge']),
      unloadingCharge: _parseDouble(json['unloadingCharge']),
      minKm: _parseNullableInt(json['minKm']),
      minHours: _parseNullableInt(json['minHours']),
      insuranceExpiry: _parseNullableString(json['insuranceExpiry']),
      extraData: json['extraData'] as Map<String, dynamic>?,
      vehiclePhotos: photos,
      specs: specsList,
      similarVehicles: similarList,
      driverDetails: json['driver'] as Map<String, dynamic>?,
      amenities: (json['amenities'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      working_areas: (json['working_areas'] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  // ── SAFE PARSERS ────────────────────────────────────────────────────────
  // API sends inconsistent types (String "12.5" vs num 12.5) — handle both

  static String _parseString(dynamic v) {
    if (v == null) return '';
    return v.toString();
  }

  static String? _parseNullableString(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v.trim()) ?? 0;
    return 0;
  }

  static int? _parseNullableInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) {
      final trimmed = v.trim();
      if (trimmed.isEmpty) return null;
      return int.tryParse(trimmed);
    }
    return null;
  }

  /// Safely parses double from String | int | double | null
  /// This is the fix for: type 'String' is not a subtype of type 'num?'
  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) {
      final trimmed = v.trim();
      if (trimmed.isEmpty) return null;
      return double.tryParse(trimmed);
    }
    return null;
  }

  static bool _parseBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }

  // ────────────────────────────────────────────────────────────────────────

  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id,
      nameKey: nameKey,
      rating: rating,
      capacity: capacity,
      fare: fare,
      eta: eta,
      categoryKey: categoryKey,
      imagePath: imagePath,
      registrationNo: registrationNo,
      driverName: driverName,
      driverPhoto: driverPhoto,
      driverTrips: driverTrips,
      isOnline: isOnline,
      make: make,
      categorySlug: categorySlug,
      categoryName: categoryName,
      description: description,
      fuelType: fuelType,
      condition: condition,
      pricingModel: pricingModel,
      basePrice: basePrice,
      extraKmCharge: extraKmCharge,
      extraHourCharge: extraHourCharge,
      driverBata: driverBata,
      operatorBata: operatorBata,
      loadingCharge: loadingCharge,
      unloadingCharge: unloadingCharge,
      minKm: minKm,
      minHours: minHours,
      insuranceExpiry: insuranceExpiry,
      extraData: extraData,
      vehiclePhotos: vehiclePhotos,
      specs: specs,
      similarVehicles: similarVehicles,
      driverDetails: driverDetails,
      amenities: amenities,
      working_areas: working_areas,
      driverPhone: driverDetails?['phone']?.toString(),
    );
  }
} /*class VehicleModel {
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
  final String? driverPhoto;
  final int driverTrips;
  final bool isOnline;
  final String? make;
  final String categorySlug;
  final String categoryName;

  const VehicleModel({
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
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: _parseInt(json['id']),
      nameKey: _parseString(json['nameKey']),
      rating: _parseString(json['rating']),
      capacity: _parseString(json['capacity']),
      fare: _parseString(json['fare']),
      eta: _parseString(json['eta']),
      categoryKey: _parseString(json['categoryKey']),
      imagePath: _parseString(json['imagePath']),
      registrationNo: _parseNullableString(json['registrationNo']),
      driverName: _parseString(json['driverName']),
      driverPhoto: _parseNullableString(json['driverPhoto']),
      driverTrips: _parseInt(json['driverTrips']),
      isOnline: _parseBool(json['isOnline']),
      make: _parseNullableString(json['make']),
      categorySlug: _parseString(json['categorySlug']),
      categoryName: _parseString(json['categoryName']),
    );
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  static String? _parseNullableString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  VehicleEntity toEntity() => VehicleEntity(
    id: id,
    nameKey: nameKey,
    rating: rating,
    capacity: capacity,
    fare: fare,
    eta: eta,
    categoryKey: categoryKey,
    imagePath: imagePath,
    registrationNo: registrationNo,
    driverName: driverName,
    driverPhoto: driverPhoto,
    driverTrips: driverTrips,
    isOnline: isOnline,
    make: make,
    categorySlug: categorySlug,
    categoryName: categoryName,
  );
}*/

// lib/features/home/data/models/vehicles_response_model.dart
// ════════════════════════════════════════════════════════════════
//  VEHICLES RESPONSE MODEL — Data Layer
// ════════════════════════════════════════════════════════════════

class VehiclesResponseModel {
  final List<VehicleModel> vehicles;
  final int total;
  final String filter;
  final int limit;
  final int offset;

  const VehiclesResponseModel({
    required this.vehicles,
    required this.total,
    required this.filter,
    required this.limit,
    required this.offset,
  });

  factory VehiclesResponseModel.fromJson(Map<String, dynamic> json) {
    // The json here is already the 'data' object from API response
    return VehiclesResponseModel(
      vehicles: _parseVehiclesList(json['vehicles']),
      total: _parseInt(json['total']),
      filter: _parseString(json['filter']),
      limit: _parseInt(json['limit']),
      offset: _parseInt(json['offset']),
    );
  }

  static List<VehicleModel> _parseVehiclesList(dynamic vehiclesData) {
    final List<VehicleModel> vehicles = [];
    final list = vehiclesData as List? ?? [];

    for (final item in list) {
      if (item is Map<String, dynamic>) {
        vehicles.add(VehicleModel.fromJson(item));
      }
    }
    return vehicles;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    return value.toString();
  }

  VehiclesResponseEntity toEntity() => VehiclesResponseEntity(
    vehicles: vehicles.map((v) => v.toEntity()).toList(),
    total: total,
    filter: filter,
    limit: limit,
    offset: offset,
  );
}
