// lib/features/booking/unified/domain/usecases/get_user_bookings_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking_details/domain/repositories/booking_repository.dart';

class GetUserBookingsUseCase {
  final BookingRepository _repository;

  const GetUserBookingsUseCase(this._repository);

  Future<ApiResult<Map<String, dynamic>>> call({
    String? status,
    int? limit = 20,
    int? offset = 0,
  }) async {
    return _repository.getUserBookings(
      status: status,
      limit: limit,
      offset: offset,
    );
  }
}
