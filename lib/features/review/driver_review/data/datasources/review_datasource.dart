// lib/features/reviews/data/datasources/review_remote_datasource.dart

import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/review/driver_review/data/model/review_response_model.dart';

abstract class ReviewRemoteDataSource {
  Future<ReviewResponseModel> getReviews(int vehicleId);
  Future<void> addReview(int vehicleId, int rating, String comment);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiService _api;

  ReviewRemoteDataSourceImpl({ApiService? api}) : _api = api ?? ApiService();

  @override
  Future<ReviewResponseModel> getReviews(int vehicleId) async {
    final res = await _api.get('/user/reviews/$vehicleId');

    if (res.isSuccess && res.data != null) {
      final data = res.data['data'];
      return ReviewResponseModel.fromJson(data);
    }

    throw ApiException(message: res.error ?? 'Failed to fetch reviews');
  }

  //'${ApiConstants.user.favorites}/$vehicleId',
  @override
  Future<void> addReview(int vehicleId, int rating, String comment) async {
    final res = await _api.post('/user/reviews/$vehicleId', {
      "rating": rating,
      "comment": comment,
    });

    // if (!res.isSuccess) {
    //   throw ApiException(message: res.error ?? 'Failed to add review');
    // }
    // ── Check both HTTP status AND response body success flag ──
    if (!res.isSuccess) {
      // Extract message from response body if available
      final body = res.data as Map<String, dynamic>?;
      final message =
          body?['message'] as String? ?? res.error ?? 'Failed to add review';
      throw ApiException(message: message);
    }

    // Some APIs return 200 but with success: false in body
    final body = res.data as Map<String, dynamic>?;
    if (body != null && body['success'] == false) {
      final message = body['message'] as String? ?? 'Failed to add review';
      throw ApiException(message: message);
    }
  }
}
