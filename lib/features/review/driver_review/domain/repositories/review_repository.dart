import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/review/driver_review/domain/entities/review_entity.dart';

abstract class ReviewRepository {
  Future<ApiResult<ReviewResponseEntity>> getReviews(int vehicleId);
  Future<ApiResult<void>> addReview(int vehicleId, int rating, String comment);
}
