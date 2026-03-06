import 'package:dartz/dartz.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';
import 'package:tiffinmate/features/items/domain/entities/paginated_items_entity.dart';

abstract interface class IAdminItemsRepository {
  Future<Either<Failure, PaginatedItemsEntity>> getItems({
    int page,
    int limit,
    String? query,
    String? category,
    bool? available,
  });

  Future<Either<Failure, ItemEntity>> getItemById(String id);

  Future<Either<Failure, ItemEntity>> updateItem({
    required String id,
    String? name,
    String? description,
    double? price,
    String? category,
    bool? available,
    String? image,
  });

  Future<Either<Failure, ItemEntity>> createItem({
    required String name,
    String? description,
    required double price,
    String? category,
    bool available,
    String? image,
  });

  Future<Either<Failure, Unit>> deleteItem(String id);
}
