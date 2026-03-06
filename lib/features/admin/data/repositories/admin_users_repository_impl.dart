import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/services/connecivity/network_info.dart';
import 'package:tiffinmate/features/admin/data/datasource/admin_users_remote_datasource.dart';
import 'package:tiffinmate/features/admin/data/models/admin_user_api_model.dart';
import 'package:tiffinmate/features/admin/domain/entities/admin_user_entity.dart';
import 'package:tiffinmate/features/admin/domain/entities/paginated_admin_users_entity.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_users_repository.dart';

final adminUsersRepositoryProvider = Provider<IAdminUsersRepository>((ref) {
  final remoteDataSource = ref.read(adminUsersRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AdminUsersRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

class AdminUsersRepositoryImpl implements IAdminUsersRepository {
  final IAdminUsersRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AdminUsersRepositoryImpl({
    required IAdminUsersRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, PaginatedAdminUsersEntity>> getUsers({int page = 1, int limit = 10}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final data = await _remoteDataSource.getUsers(page: page, limit: limit);
      final usersJson = data['users'] as List<dynamic>? ?? [];
      final users = AdminUserApiModel.toEntityList(usersJson);

      final total = (data['total'] ?? 0) as int;
      final currentPage = (data['page'] ?? page) as int;
      final currentLimit = (data['limit'] ?? limit) as int;
      final totalPages = (data['totalPages'] ?? 1) as int;

      return Right(
        PaginatedAdminUsersEntity(
          users: users,
          total: total,
          page: currentPage,
          limit: currentLimit,
          totalPages: totalPages,
        ),
      );
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to load users').toString()
          : 'Failed to load users';
      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> getUser(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.getUser(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to load user').toString()
          : 'Failed to load user';
      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> createUser({
    required String email,
    required String username,
    required String password,
    String? confirmPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.createUser(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to create user').toString()
          : 'Failed to create user';
      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> updateUser({
    required String id,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.updateUser(
        id: id,
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to update user').toString()
          : 'Failed to update user';
      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteUser(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      await _remoteDataSource.deleteUser(id);
      return const Right(unit);
    } on DioException catch (e) {
      final message = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to delete user').toString()
          : 'Failed to delete user';
      return Left(ApiFailure(message: message, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
