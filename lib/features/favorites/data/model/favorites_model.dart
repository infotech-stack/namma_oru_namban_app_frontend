import 'package:userapp/features/favorites/domain/entities/favorite_entity.dart';

class FavoriteModel {
  final int id;
  final String nameKey;
  final String rating;
  final String capacity;
  final String fare;
  final String eta;
  final String categoryKey;
  final String availabilityStatus;
  final String? imagePath;

  FavoriteModel({
    required this.id,
    required this.nameKey,
    required this.rating,
    required this.capacity,
    required this.fare,
    required this.eta,
    required this.categoryKey,
    required this.availabilityStatus,
    this.imagePath,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: _parseInt(json['id']),
      nameKey: _parseString(json['nameKey']),
      rating: _parseString(json['rating']),
      capacity: _parseString(json['capacity']),
      fare: _parseString(json['fare']),
      eta: _parseString(json['eta']),
      categoryKey: _parseString(json['categoryKey']),
      availabilityStatus: _parseString(json['availabilityStatus']),
      imagePath: _parseNullableString(json['imagePath']),
    );
  }

  // ── SAFE PARSERS (same pattern as VehicleModel) ──

  static String _parseString(dynamic v) {
    if (v == null) return '';
    return v.toString();
  }

  static String? _parseNullableString(dynamic v) {
    if (v == null) return null;
    final val = v.toString().trim();
    return val.isEmpty ? null : val;
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    if (v is double) return v.toInt();
    return 0;
  }

  // ── Convert to Entity ──
  FavoriteEntity toEntity() {
    return FavoriteEntity(
      id: id,
      nameKey: nameKey,
      rating: rating,
      capacity: capacity,
      fare: fare,
      eta: eta,
      categoryKey: categoryKey,
      availabilityStatus: availabilityStatus,
      imagePath: imagePath,
    );
  }
}
