// lib/features/address/domain/entities/address_entity.dart

class AddressEntity {
  final int id;
  final int userId;
  final String label;
  final String address;
  final double lat;
  final double lng;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddressEntity({
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

  // ── Computed ─────────────────────────────────────────────────
  String get displayLabel {
    switch (label.toLowerCase()) {
      case 'home':
        return 'label_home';
      case 'work':
        return 'label_work';
      case 'other':
        return 'label_other';
      default:
        return label;
    }
  }

  String get shortAddress {
    final parts = address.split(',');
    return parts.isNotEmpty ? parts.first.trim() : address;
  }
}
