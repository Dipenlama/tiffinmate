import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/api/api_client.dart';
import 'package:tiffinmate/core/api/api_endpoints.dart';
import 'package:tiffinmate/features/bookings/data/models/booking_api_model.dart';
import 'package:tiffinmate/features/bookings/domain/entities/paginated_bookings_entity.dart';

abstract interface class IBookingsRemoteDataSource {
  Future<BookingApiModel> createBooking(Map<String, dynamic> body);
  Future<PaginatedBookingsEntity> getBookings({int page, int limit});
  Future<BookingApiModel> getBookingDetail(String id);
}

final bookingsRemoteDataSourceProvider = Provider<IBookingsRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return BookingsRemoteDataSource(client.dio);
});

class BookingsRemoteDataSource implements IBookingsRemoteDataSource {
  final Dio _dio;

  BookingsRemoteDataSource(this._dio);

  @override
  Future<BookingApiModel> createBooking(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiEndpoints.bookings, data: body);
    final data = response.data;
    if (data['success'] == true) {
      return BookingApiModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: data['error']?['message'] ?? 'Failed to create booking',
    );
  }

  @override
  Future<PaginatedBookingsEntity> getBookings({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      ApiEndpoints.bookings,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    final data = response.data;
    if (data['success'] == true) {
      final result = data['data'] as Map<String, dynamic>;
      final items = (result['items'] as List<dynamic>)
          .map((e) => BookingApiModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return PaginatedBookingsEntity(
        items: items,
        total: result['total'] as int,
        page: result['page'] as int,
        limit: result['limit'] as int,
        totalPages: result['totalPages'] as int,
      );
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: data['error']?['message'] ?? 'Failed to load bookings',
    );
  }

  @override
  Future<BookingApiModel> getBookingDetail(String id) async {
    final response = await _dio.get('${ApiEndpoints.bookings}/$id');
    final data = response.data;
    if (data['success'] == true) {
      return BookingApiModel.fromJson(data['data'] as Map<String, dynamic>);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      error: data['error']?['message'] ?? 'Failed to load booking detail',
    );
  }
}
