// ════════════════════════════════════════════════════════════════
//  GET BOOKING DETAIL USE CASE — Domain Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_detail_entity.dart';
import 'package:userapp/features/booking/domain/repositories/my_booking_detail_repository.dart';

class GetBookingDetailUseCase {
  final MyBookingDetailRepository _repository;

  const GetBookingDetailUseCase(this._repository);

  Future<ApiResult<MyBookingDetailEntity>> call(int id) {
    return _repository.getBookingDetail(id);
  }
}
