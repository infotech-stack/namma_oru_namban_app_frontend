// lib/features/reviews/data/repositories/review_repository_impl.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/review/driver_review/data/datasources/review_datasource.dart';
import 'package:userapp/features/review/driver_review/domain/entities/review_entity.dart';
import 'package:userapp/features/review/driver_review/domain/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _ds;

  ReviewRepositoryImpl({ReviewRemoteDataSource? ds})
    : _ds = ds ?? ReviewRemoteDataSourceImpl();

  @override
  Future<ApiResult<ReviewResponseEntity>> getReviews(int vehicleId) async {
    try {
      final res = await _ds.getReviews(vehicleId);
      return ApiResult.success(res.toEntity());
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }

  @override
  Future<ApiResult<void>> addReview(
    int vehicleId,
    int rating,
    String comment,
  ) async {
    try {
      await _ds.addReview(vehicleId, rating, comment);
      return ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(e.toString());
    }
  }
}
