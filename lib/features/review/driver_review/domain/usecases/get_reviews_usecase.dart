// lib/features/reviews/domain/usecases/get_reviews_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/review/driver_review/domain/entities/review_entity.dart';
import 'package:userapp/features/review/driver_review/domain/repositories/review_repository.dart';

class GetReviewsUseCase {
  final ReviewRepository repo;

  GetReviewsUseCase(this.repo);

  Future<ApiResult<ReviewResponseEntity>> call(int vehicleId) {
    return repo.getReviews(vehicleId);
  }
}
