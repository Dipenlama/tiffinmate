import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_users_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/entities/admin_user_entity.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_users_repository.dart';

class CreateAdminUserParams extends Equatable {
  final String email;
  final String username;
  final String password;
  final String? confirmPassword;

  const CreateAdminUserParams({
    required this.email,
    required this.username,
    required this.password,
    this.confirmPassword,
  });

  @override
  List<Object?> get props => [email, username, password, confirmPassword];
}

final createAdminUserUsecaseProvider = Provider<CreateAdminUserUsecase>((ref) {
  final repo = ref.read(adminUsersRepositoryProvider);
  return CreateAdminUserUsecase(repository: repo);
});

class CreateAdminUserUsecase
    implements UsecaseWithParms<AdminUserEntity, CreateAdminUserParams> {
  final IAdminUsersRepository _repository;

  CreateAdminUserUsecase({required IAdminUsersRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, AdminUserEntity>> call(
    CreateAdminUserParams params,
  ) {
    return _repository.createUser(
      email: params.email,
      username: params.username,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}
