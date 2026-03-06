import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/services/connecivity/network_info.dart';
import 'package:tiffinmate/features/bookings/data/datasource/bookings_remote_datasource.dart';
import 'package:tiffinmate/features/bookings/data/models/booking_api_model.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:tiffinmate/features/bookings/domain/entities/paginated_bookings_entity.dart';
import 'package:tiffinmate/features/bookings/domain/repositories/bookings_repository.dart';

final bookingsRepositoryProvider = Provider<IBookingsRepository>((ref) {
  final remote = ref.read(bookingsRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BookingsRepository(remoteDataSource: remote, networkInfo: networkInfo);
});

class BookingsRepository implements IBookingsRepository {
  final IBookingsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  BookingsRepository({
    required IBookingsRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, BookingEntity>> createBooking({
    required List<BookingItemForCreate> items,
    required double total,
    required String day,
    required String time,
    required String frequency,
    String? draftId,
    String? package,
    String? packageName,
    String? address,
    String? notes,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    final body = <String, dynamic>{
      if (draftId != null && draftId.isNotEmpty) 'draftId': draftId,
      'items': items
          .map((e) => {
                'id': e.id,
                'name': e.name,
                'qty': e.qty,
                'price': e.price,
                'subtotal': e.subtotal,
              })
          .toList(),
      'total': total,
      'day': day,
      'time': time,
      'frequency': frequency,
      if (package != null && package.isNotEmpty) 'package': package,
      if (packageName != null && packageName.isNotEmpty) 'packageName': packageName,
      if (address != null && address.isNotEmpty) 'address': address,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    try {
      final BookingApiModel apiModel = await _remoteDataSource.createBooking(body);
      return Right(apiModel.toEntity());
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Failed to create booking';

      if (data is Map<String, dynamic>) {
        final errorObj = data['error'];
        if (errorObj is Map<String, dynamic> && errorObj['message'] is String) {
          message = errorObj['message'] as String;
        } else if (data['message'] is String) {
          message = data['message'] as String;
        }
      } else if (e.message != null) {
        message = e.message!;
      }

      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaginatedBookingsEntity>> getBookings({
    int page = 1,
    int limit = 10,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final result = await _remoteDataSource.getBookings(page: page, limit: limit);
      return Right(result);
    } on DioException catch (e) {
      final message = e.response?.data['error']?['message'] ?? 'Failed to load bookings';
      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingDetail(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final apiModel = await _remoteDataSource.getBookingDetail(id);
      return Right(apiModel.toEntity());
    } on DioException catch (e) {
      final message = e.response?.data['error']?['message'] ?? 'Failed to load booking detail';
      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
