import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_items_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_items_repository.dart';

class DeleteAdminItemParams extends Equatable {
  final String id;

  const DeleteAdminItemParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteAdminItemUsecaseProvider = Provider<DeleteAdminItemUsecase>((ref) {
  final repo = ref.read(adminItemsRepositoryProvider);
  return DeleteAdminItemUsecase(repository: repo);
});

class DeleteAdminItemUsecase
    implements UsecaseWithParms<Unit, DeleteAdminItemParams> {
  final IAdminItemsRepository _repository;

  DeleteAdminItemUsecase({required IAdminItemsRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteAdminItemParams params) {
    return _repository.deleteItem(params.id);
  }
}
