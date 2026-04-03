// lib/features/reviews/data/models/review_model.dart

import 'package:userapp/features/review/driver_review/domain/entities/review_entity.dart';

class ReviewModel {
  final int id;
  final String name;
  final String avatar;
  final int rating;
  final String comment;
  final String date;
  final bool isOwner;

  ReviewModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
    required this.isOwner,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      avatar: _parseString(json['avatar']),
      rating: _parseInt(json['rating']),
      comment: _parseString(json['comment']),
      date: _parseString(json['date']),
      isOwner: _parseBool(json['isOwner']),
    );
  }

  ReviewEntity toEntity() {
    return ReviewEntity(
      id: id,
      name: name,
      avatar: avatar,
      rating: rating,
      comment: comment,
      date: date,
      isOwner: isOwner,
    );
  }

  static int _parseInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static String _parseString(dynamic v) => v?.toString() ?? '';

  static bool _parseBool(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v == 1;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }
}
