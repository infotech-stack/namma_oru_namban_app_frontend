class FavoriteEntity {
  final int id;
  final String nameKey;
  final String rating;
  final String capacity;
  final String fare;
  final String eta;
  final String categoryKey;
  final String availabilityStatus;
  final String? imagePath;

  const FavoriteEntity({
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
}
