import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_items_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_items_repository.dart';
import 'package:tiffinmate/features/items/domain/entities/paginated_items_entity.dart';

class GetAdminItemsParams extends Equatable {
  final int page;
  final int limit;

  const GetAdminItemsParams({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

final getAdminItemsUsecaseProvider = Provider<GetAdminItemsUsecase>((ref) {
  final repo = ref.read(adminItemsRepositoryProvider);
  return GetAdminItemsUsecase(repository: repo);
});

class GetAdminItemsUsecase
    implements UsecaseWithParms<PaginatedItemsEntity, GetAdminItemsParams> {
  final IAdminItemsRepository _repository;

  GetAdminItemsUsecase({required IAdminItemsRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, PaginatedItemsEntity>> call(
    GetAdminItemsParams params,
  ) {
    return _repository.getItems(page: params.page, limit: params.limit);
  }
}
