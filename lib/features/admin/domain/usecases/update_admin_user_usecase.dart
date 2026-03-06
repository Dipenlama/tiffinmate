import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_users_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/entities/admin_user_entity.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_users_repository.dart';

class UpdateAdminUserParams extends Equatable {
  final String id;
  final String? email;
  final String? username;
  final String? password;
  final String? confirmPassword;

  const UpdateAdminUserParams({
    required this.id,
    this.email,
    this.username,
    this.password,
    this.confirmPassword,
  });

  @override
  List<Object?> get props => [id, email, username, password, confirmPassword];
}

final updateAdminUserUsecaseProvider = Provider<UpdateAdminUserUsecase>((ref) {
  final repo = ref.read(adminUsersRepositoryProvider);
  return UpdateAdminUserUsecase(repository: repo);
});

class UpdateAdminUserUsecase
    implements UsecaseWithParms<AdminUserEntity, UpdateAdminUserParams> {
  final IAdminUsersRepository _repository;

  UpdateAdminUserUsecase({required IAdminUsersRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AdminUserEntity>> call(
    UpdateAdminUserParams params,
  ) {
    return _repository.updateUser(
      id: params.id,
      email: params.email,
      username: params.username,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}
