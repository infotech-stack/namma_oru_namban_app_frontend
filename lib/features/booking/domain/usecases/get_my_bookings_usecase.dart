// lib/features/booking/domain/usecases/get_my_bookings_usecase.dart
// ════════════════════════════════════════════════════════════════
//  GET MY BOOKINGS USE CASE — Domain Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_entity.dart';
import 'package:userapp/features/booking/domain/repositories/my_booking_repository.dart';

class GetMyBookingsUseCase {
  final MyBookingRepository _repository;

  const GetMyBookingsUseCase(this._repository);

  Future<ApiResult<MyBookingsResponseEntity>> call({int? limit, int? offset}) {
    return _repository.getMyBookings(limit: limit, offset: offset);
  }
}
