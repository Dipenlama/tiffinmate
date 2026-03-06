import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/services/connecivity/network_info.dart';
import 'package:tiffinmate/features/admin/data/datasource/admin_bookings_remote_datasource.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_bookings_repository.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:tiffinmate/features/bookings/domain/entities/paginated_bookings_entity.dart';

final adminBookingsRepositoryProvider = Provider<IAdminBookingsRepository>((ref) {
  final remote = ref.read(adminBookingsRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AdminBookingsRepositoryImpl(remoteDataSource: remote, networkInfo: networkInfo);
});

class AdminBookingsRepositoryImpl implements IAdminBookingsRepository {
  final IAdminBookingsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AdminBookingsRepositoryImpl({
    required IAdminBookingsRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, PaginatedBookingsEntity>> getBookings({
    int page = 1,
    int limit = 10,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final data = await _remoteDataSource.getBookings(page: page, limit: limit);
      return Right(data);
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to load bookings').toString()
          : 'Failed to load bookings';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBooking(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.getBooking(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to load booking').toString()
          : 'Failed to load booking';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> updateStatus(
    String id,
    String status,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.updateStatus(id, status);
      return Right(model.toEntity());
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to update status').toString()
          : 'Failed to update status';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.cancelBooking(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to cancel booking').toString()
          : 'Failed to cancel booking';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
