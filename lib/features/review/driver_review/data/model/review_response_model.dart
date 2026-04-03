// lib/features/reviews/data/models/review_response_model.dart

import 'package:userapp/features/review/driver_review/domain/entities/review_entity.dart';

import 'review_model.dart';

class ReviewResponseModel {
  final List<ReviewModel> reviews;
  final int total;
  final int avgRating;
  final bool isEmpty;

  ReviewResponseModel({
    required this.reviews,
    required this.total,
    required this.avgRating,
    required this.isEmpty,
  });

  factory ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return ReviewResponseModel(
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
      total: _parseInt(json['total']),
      avgRating: _parseInt(json['avgRating']),
      isEmpty: json['isEmpty'] ?? false,
    );
  }

  ReviewResponseEntity toEntity() {
    return ReviewResponseEntity(
      reviews: reviews.map((e) => e.toEntity()).toList(),
      total: total,
      avgRating: avgRating,
      isEmpty: isEmpty,
    );
  }

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
