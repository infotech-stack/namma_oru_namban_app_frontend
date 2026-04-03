// lib/features/booking/unified/domain/usecases/cancel_booking_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking_details/domain/repositories/booking_repository.dart';

class CancelBookingUseCase {
  final BookingRepository _repository;

  const CancelBookingUseCase(this._repository);

  Future<ApiResult<Map<String, dynamic>>> call(int bookingId) async {
    return _repository.cancelBooking(bookingId);
  }
}
