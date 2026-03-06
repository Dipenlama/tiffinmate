import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/items/domain/entities/paginated_items_entity.dart';
import 'package:tiffinmate/features/items/domain/repositories/items_repository.dart';
import 'package:tiffinmate/features/items/data/repositories/items_repository_impl.dart';

class GetItemsParams extends Equatable {
  final int page;
  final int limit;
  final String? query;
  final String? category;
  final bool? available;

  const GetItemsParams({
    this.page = 1,
    this.limit = 10,
    this.query,
    this.category,
    this.available,
  });

  @override
  List<Object?> get props => [page, limit, query, category, available];
}

final getItemsUsecaseProvider = Provider<GetItemsUsecase>((ref) {
  final repo = ref.read(itemsRepositoryProvider);
  return GetItemsUsecase(itemsRepository: repo);
});

class GetItemsUsecase
    implements UsecaseWithParms<PaginatedItemsEntity, GetItemsParams> {
  final IItemsRepository _itemsRepository;

  GetItemsUsecase({required IItemsRepository itemsRepository})
      : _itemsRepository = itemsRepository;

  @override
  Future<Either<Failure, PaginatedItemsEntity>> call(GetItemsParams params) {
    return _itemsRepository.getItems(
      page: params.page,
      limit: params.limit,
      query: params.query,
      category: params.category,
      available: params.available,
    );
  }
}
