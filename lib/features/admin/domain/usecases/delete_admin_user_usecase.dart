import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_users_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_users_repository.dart';

class DeleteAdminUserParams extends Equatable {
  final String id;

  const DeleteAdminUserParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteAdminUserUsecaseProvider = Provider<DeleteAdminUserUsecase>((ref) {
  final repo = ref.read(adminUsersRepositoryProvider);
  return DeleteAdminUserUsecase(repository: repo);
});

class DeleteAdminUserUsecase
    implements UsecaseWithParms<Unit, DeleteAdminUserParams> {
  final IAdminUsersRepository _repository;

  DeleteAdminUserUsecase({required IAdminUsersRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteAdminUserParams params) {
    return _repository.deleteUser(params.id);
  }
}
