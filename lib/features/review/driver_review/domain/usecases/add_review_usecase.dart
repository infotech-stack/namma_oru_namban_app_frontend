import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/review/driver_review/domain/repositories/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository repo;

  AddReviewUseCase(this.repo);

  Future<ApiResult<void>> call(int vehicleId, int rating, String comment) {
    return repo.addReview(vehicleId, rating, comment);
  }
}
