// lib/features/booking/unified/domain/usecases/get_booking_detail_usecase.dart

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking_details/domain/repositories/booking_repository.dart';

class GetBookingDetailUseCase {
  final BookingRepository _repository;

  const GetBookingDetailUseCase(this._repository);

  Future<ApiResult<Map<String, dynamic>>> call(int bookingId) async {
    return _repository.getBookingDetail(bookingId);
  }
}
