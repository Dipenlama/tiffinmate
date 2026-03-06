import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_items_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_items_repository.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';

class UpdateAdminItemParams extends Equatable {
  final String id;
  final String? name;
  final String? description;
  final double? price;
  final String? category;
  final bool? available;
  final String? image;

  const UpdateAdminItemParams({
    required this.id,
    this.name,
    this.description,
    this.price,
    this.category,
    this.available,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, description, price, category, available, image];
}

final updateAdminItemUsecaseProvider = Provider<UpdateAdminItemUsecase>((ref) {
  final repo = ref.read(adminItemsRepositoryProvider);
  return UpdateAdminItemUsecase(repository: repo);
});

class UpdateAdminItemUsecase
    implements UsecaseWithParms<ItemEntity, UpdateAdminItemParams> {
  final IAdminItemsRepository _repository;

  UpdateAdminItemUsecase({required IAdminItemsRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, ItemEntity>> call(UpdateAdminItemParams params) {
    return _repository.updateItem(
      id: params.id,
      name: params.name,
      description: params.description,
      price: params.price,
      category: params.category,
      available: params.available,
      image: params.image,
    );
  }
}
