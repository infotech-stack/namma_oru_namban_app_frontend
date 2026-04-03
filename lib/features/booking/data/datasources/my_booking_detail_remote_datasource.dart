// lib/features/booking/data/datasource/my_booking_detail_remote_datasource.dart

import 'package:userapp/core/network/api_constants.dart';
import 'package:userapp/core/network/api_exception.dart';
import 'package:userapp/core/network/api_service.dart';
import 'package:userapp/features/booking/data/model/my_booking_detail_model.dart';

abstract class MyBookingDetailRemoteDataSource {
  Future<MyBookingDetailModel> getBookingDetail(int id);
}

class MyBookingDetailRemoteDataSourceImpl
    implements MyBookingDetailRemoteDataSource {
  final ApiService _api;

  MyBookingDetailRemoteDataSourceImpl({ApiService? apiService})
    : _api = apiService ?? ApiService();

  // ── GET /api/v1/user/bookings/:id ──────────────────────────────
  @override
  Future<MyBookingDetailModel> getBookingDetail(int id) async {
    try {
      // ✅ FIX: Call the function correctly with the id parameter
      // ApiConstants.user.bookingDetail is a FUNCTION that takes id
      final url = ApiConstants.user.bookingDetail(id.toString());

      // Alternative if your base URL already has /api/v1:
      // final url = ApiConstants.user.bookingDetail(id.toString());

      print('🔍 Fetching booking detail from URL: $url');

      final result = await _api.get(url);

      if (result.isSuccess && result.data != null) {
        final responseData = result.data as Map<String, dynamic>;

        // Check if response has 'data' wrapper
        final detailData = responseData['data'] as Map<String, dynamic>?;

        if (detailData == null) {
          throw ApiException(
            message: 'Invalid response format: missing data field',
            type: ApiErrorType.unknown,
          );
        }

        return MyBookingDetailModel.fromJson(detailData);
      }

      throw ApiException(
        message: result.error ?? 'Failed to fetch booking detail',
        type: result.exception?.type ?? ApiErrorType.unknown,
        statusCode: result.exception?.statusCode,
      );
    } catch (e) {
      print('❌ Error fetching booking detail: $e');
      rethrow;
    }
  }
}
