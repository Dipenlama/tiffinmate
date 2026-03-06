import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/api/api_client.dart';
import 'package:tiffinmate/core/api/api_endpoints.dart';
import 'package:tiffinmate/features/bookings/data/models/booking_api_model.dart';
import 'package:tiffinmate/features/bookings/domain/entities/paginated_bookings_entity.dart';

abstract interface class IAdminBookingsRemoteDataSource {
  Future<PaginatedBookingsEntity> getBookings({int page, int limit});
  Future<BookingApiModel> getBooking(String id);
  Future<BookingApiModel> updateStatus(String id, String status);
  Future<BookingApiModel> cancelBooking(String id);
}

final adminBookingsRemoteDataSourceProvider =
    Provider<IAdminBookingsRemoteDataSource>((ref) {
  final client = ref.read(apiClientProvider);
  return AdminBookingsRemoteDataSource(apiClient: client);
});

class AdminBookingsRemoteDataSource implements IAdminBookingsRemoteDataSource {
  final ApiClient _apiClient;

  AdminBookingsRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<PaginatedBookingsEntity> getBookings({int page = 1, int limit = 10}) async {
    final response = await _apiClient.get(
      ApiEndpoints.adminBookings,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );

    final root = response.data as Map<String, dynamic>;
    final data = root['data'] as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>)
        .map((e) => BookingApiModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();

    return PaginatedBookingsEntity(
      items: items,
      total: data['total'] as int,
      page: data['page'] as int,
      limit: data['limit'] as int,
      totalPages: data['totalPages'] as int,
    );
  }

  @override
  Future<BookingApiModel> getBooking(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.adminBookings}/$id');
    final root = response.data as Map<String, dynamic>;
    final data = root['data'] as Map<String, dynamic>;
    return BookingApiModel.fromJson(data);
  }

  @override
  Future<BookingApiModel> updateStatus(String id, String status) async {
    final response = await _apiClient.put(
      '${ApiEndpoints.adminBookings}/$id/status',
      data: {
        'status': status,
      },
    );
    final root = response.data as Map<String, dynamic>;
    final data = root['data'] as Map<String, dynamic>;
    return BookingApiModel.fromJson(data);
  }

  @override
  Future<BookingApiModel> cancelBooking(String id) async {
    final response = await _apiClient.delete('${ApiEndpoints.adminBookings}/$id');
    final root = response.data as Map<String, dynamic>;
    final data = root['data'] as Map<String, dynamic>;
    return BookingApiModel.fromJson(data);
  }
}
