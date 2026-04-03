// lib/features/booking/unified/domain/usecases/create_booking_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking_details/domain/repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository _repository;

  const CreateBookingUseCase(this._repository);

  Future<ApiResult<Map<String, dynamic>>> call(
    Map<String, dynamic> params,
  ) async {
    return _repository.createBooking(params);
  }
}
