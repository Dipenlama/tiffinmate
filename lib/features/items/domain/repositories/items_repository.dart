import 'package:dartz/dartz.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';
import 'package:tiffinmate/features/items/domain/entities/paginated_items_entity.dart';

abstract interface class IItemsRepository {
  Future<Either<Failure, PaginatedItemsEntity>> getItems({
    int page,
    int limit,
    String? query,
    String? category,
    bool? available,
  });

  Future<Either<Failure, ItemEntity>> getItemById(String id);
}
