// lib/features/reviews/data/models/review_response_model.dart

import 'package:userapp/features/review/driver_review/domain/entities/review_entity.dart';

import 'review_model.dart';
//── My Review Model ───────────────────────────────────────────────────────────

class MyReviewModel {
  final int id;
  final int rating;
  final String comment;
  final String date;

  const MyReviewModel({
    required this.id,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory MyReviewModel.fromJson(Map<String, dynamic> json) {
    return MyReviewModel(
      id: _parseInt(json['id']),
      rating: _parseInt(json['rating']),
      comment: json['comment'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  MyReviewEntity toEntity() =>
      MyReviewEntity(id: id, rating: rating, comment: comment, date: date);
}
// ── Response Model ────────────────────────────────────────────────────────────

class ReviewResponseModel {
  final List<ReviewModel> reviews;
  final int total;
  final double avgRating;
  final bool isEmpty;
  final bool hasReviewed;
  final MyReviewModel? myReview;
  final int limit;
  final int offset;

  const ReviewResponseModel({
    required this.reviews,
    required this.total,
    required this.avgRating,
    required this.isEmpty,
    required this.hasReviewed,
    this.myReview,
    required this.limit,
    required this.offset,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      reviews: (json['reviews'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(ReviewModel.fromJson)
          .toList(),
      total: _parseInt(json['total']),
      avgRating: _parseDouble(json['avgRating']),
      isEmpty: json['isEmpty'] as bool? ?? false,
      hasReviewed: json['hasReviewed'] as bool? ?? false,
      myReview: json['myReview'] != null
          ? MyReviewModel.fromJson(json['myReview'] as Map<String, dynamic>)
          : null,
      limit: _parseInt(json['limit']),
      offset: _parseInt(json['offset']),
    );
  }

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static double _parseDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  ReviewResponseEntity toEntity() => ReviewResponseEntity(
    reviews: reviews.map((r) => r.toEntity()).toList(),
    total: total,
    avgRating: avgRating,
    isEmpty: isEmpty,
    hasReviewed: hasReviewed,
    myReview: myReview?.toEntity(),
    limit: limit,
    offset: offset,
  );
}
