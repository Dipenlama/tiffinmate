import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/services/connecivity/network_info.dart';
import 'package:tiffinmate/features/admin/data/datasource/admin_items_remote_datasource.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_items_repository.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';
import 'package:tiffinmate/features/items/domain/entities/paginated_items_entity.dart';

final adminItemsRepositoryProvider = Provider<IAdminItemsRepository>((ref) {
  final remote = ref.read(adminItemsRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AdminItemsRepositoryImpl(remoteDataSource: remote, networkInfo: networkInfo);
});

class AdminItemsRepositoryImpl implements IAdminItemsRepository {
  final IAdminItemsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AdminItemsRepositoryImpl({
    required IAdminItemsRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, PaginatedItemsEntity>> getItems({
    int page = 1,
    int limit = 10,
    String? query,
    String? category,
    bool? available,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final (models, total, currentPage, pageLimit, totalPages) =
          await _remoteDataSource.getItems(
        page: page,
        limit: limit,
        query: query,
        category: category,
        available: available,
      );

      final items = models.map((e) => e.toEntity()).toList();
      return Right(PaginatedItemsEntity(
        items: items,
        total: total,
        page: currentPage,
        limit: pageLimit,
        totalPages: totalPages,
      ));
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to load items').toString()
          : 'Failed to load items';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> getItemById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.getItemById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to load item').toString()
          : 'Failed to load item';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> updateItem({
    required String id,
    String? name,
    String? description,
    double? price,
    String? category,
    bool? available,
    String? image,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.updateItem(
        id: id,
        name: name,
        description: description,
        price: price,
        category: category,
        available: available,
        image: image,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to update item').toString()
          : 'Failed to update item';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemEntity>> createItem({
    required String name,
    String? description,
    required double price,
    String? category,
    bool available = true,
    String? image,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      final model = await _remoteDataSource.createItem(
        name: name,
        description: description,
        price: price,
        category: category,
        available: available,
        image: image,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to create item').toString()
          : 'Failed to create item';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteItem(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }

    try {
      await _remoteDataSource.deleteItem(id);
      return const Right(unit);
    } on DioException catch (e) {
      final msg = e.response?.data is Map<String, dynamic>
          ? (e.response!.data['message'] ?? 'Failed to delete item').toString()
          : 'Failed to delete item';
      return Left(ApiFailure(message: msg, statusCode: e.response?.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
