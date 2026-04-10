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
// ── My Review Entity ──────────────────────────────────────────────────────────

class MyReviewEntity {
  final int id;
  final int rating;
  final String comment;
  final String date;

  const MyReviewEntity({
    required this.id,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class ReviewResponseEntity {
  final List<ReviewEntity> reviews;
  final int total;
  final double avgRating; // ← double (API sends 2.0 not 2)
  final bool isEmpty;
  final bool hasReviewed; // ← new
  final MyReviewEntity? myReview; // ← new
  final int limit;
  final int offset;

  const ReviewResponseEntity({
    required this.reviews,
    required this.total,
    required this.avgRating,
    required this.isEmpty,
    required this.hasReviewed,
    this.myReview,
    required this.limit,
    required this.offset,
  });
}
