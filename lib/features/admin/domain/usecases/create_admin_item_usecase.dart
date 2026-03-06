import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_items_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_items_repository.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';

class CreateAdminItemParams extends Equatable {
  final String name;
  final String? description;
  final double price;
  final String? category;
  final bool available;
  final String? image;

  const CreateAdminItemParams({
    required this.name,
    this.description,
    required this.price,
    this.category,
    this.available = true,
    this.image,
  });

  @override
  List<Object?> get props => [name, description, price, category, available, image];
}

final createAdminItemUsecaseProvider = Provider<CreateAdminItemUsecase>((ref) {
  final repo = ref.read(adminItemsRepositoryProvider);
  return CreateAdminItemUsecase(repository: repo);
});

class CreateAdminItemUsecase
    implements UsecaseWithParms<ItemEntity, CreateAdminItemParams> {
  final IAdminItemsRepository _repository;

  CreateAdminItemUsecase({required IAdminItemsRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, ItemEntity>> call(CreateAdminItemParams params) {
    return _repository.createItem(
      name: params.name,
      description: params.description,
      price: params.price,
      category: params.category,
      available: params.available,
      image: params.image,
    );
  }
}
