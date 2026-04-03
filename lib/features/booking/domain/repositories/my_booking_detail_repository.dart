// ════════════════════════════════════════════════════════════════
//  MY BOOKING DETAIL REPOSITORY — Domain Layer
// ════════════════════════════════════════════════════════════════

import 'package:userapp/core/network/api_result.dart';
import 'package:userapp/features/booking/domain/entities/my_booking_detail_entity.dart';

abstract class MyBookingDetailRepository {
  Future<ApiResult<MyBookingDetailEntity>> getBookingDetail(int id);
}
