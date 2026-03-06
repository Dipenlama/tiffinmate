import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';
import 'package:tiffinmate/features/items/domain/repositories/items_repository.dart';
import 'package:tiffinmate/features/items/data/repositories/items_repository_impl.dart';

class GetItemDetailParams extends Equatable {
  final String id;

  const GetItemDetailParams(this.id);

  @override
  List<Object?> get props => [id];
}

final getItemDetailUsecaseProvider = Provider<GetItemDetailUsecase>((ref) {
  final repo = ref.read(itemsRepositoryProvider);
  return GetItemDetailUsecase(itemsRepository: repo);
});

class GetItemDetailUsecase
    implements UsecaseWithParms<ItemEntity, GetItemDetailParams> {
  final IItemsRepository _itemsRepository;

  GetItemDetailUsecase({required IItemsRepository itemsRepository})
      : _itemsRepository = itemsRepository;

  @override
  Future<Either<Failure, ItemEntity>> call(GetItemDetailParams params) {
    return _itemsRepository.getItemById(params.id);
  }
}
