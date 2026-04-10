// lib/features/address/data/model/address_model.dart

import 'package:userapp/features/profile/presentation/screen/address/domain/entities/address_entity.dart';

class AddressModel {
  final int id;
  final int userId;
  final String label;
  final String address;
  final double lat;
  final double lng;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.address,
    required this.lat,
    required this.lng,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      label: _parseString(json['label']),
      address: _parseString(json['address']),
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
      isDefault: _parseBool(json['is_default']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at'] ?? json['created_at']),
    );
  }

  // ── Safe parsers ──────────────────────────────────────────────
  static String _parseString(dynamic v) => v?.toString() ?? '';

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v.trim()) ?? 0.0;
    return 0.0;
  }

  static bool _parseBool(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }

  static DateTime _parseDateTime(dynamic v) {
    if (v is String && v.isNotEmpty) {
      return DateTime.tryParse(v) ?? DateTime.now();
    }
    return DateTime.now();
  }

  AddressEntity toEntity() => AddressEntity(
    id: id,
    userId: userId,
    label: label,
    address: address,
    lat: lat,
    lng: lng,
    isDefault: isDefault,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
