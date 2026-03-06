import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/services/connecivity/network_info.dart';
import 'package:tiffinmate/features/items/data/datasource/items_remote_datasource.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';
import 'package:tiffinmate/features/items/domain/entities/paginated_items_entity.dart';
import 'package:tiffinmate/features/items/domain/repositories/items_repository.dart';

final itemsRepositoryProvider = Provider<IItemsRepository>((ref) {
  final remote = ref.read(itemsRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ItemsRepositoryImpl(remoteDataSource: remote, networkInfo: networkInfo);
});

class ItemsRepositoryImpl implements IItemsRepository {
  final IItemsRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  ItemsRepositoryImpl({
    required IItemsRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
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

      final entities = models.map((m) => m.toEntity()).toList();

      return Right(PaginatedItemsEntity(
        items: entities,
        total: total,
        page: currentPage,
        limit: pageLimit,
        totalPages: totalPages,
      ));
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
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
