// lib/features/reviews/domain/entities/review_entity.dart

class ReviewEntity {
  final int id;
  final String name;
  final String avatar;
  final int rating;
  final String comment;
  final String date;
  final bool isOwner;

  const ReviewEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
    required this.isOwner,
  });
}

class ReviewResponseEntity {
  final List<ReviewEntity> reviews;
  final int total;
  final int avgRating;
  final bool isEmpty;

  const ReviewResponseEntity({
    required this.reviews,
    required this.total,
    required this.avgRating,
    required this.isEmpty,
  });
}
