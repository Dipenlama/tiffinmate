import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/auth/data/repositories/auth_repository.dart';
import 'package:tiffinmate/features/auth/domain/entities/auth_entity.dart';
import 'package:tiffinmate/features/auth/domain/repositories/auth_repository.dart';



class RegisterUsecaseParams extends Equatable {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;


  const RegisterUsecaseParams({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,

  });

  @override
  List<Object?> get props => [
    username,
    email,
    password,
    confirmPassword,
  ];
}

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParms<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final authEntity = AuthEntity(
      username: params.username,
      email: params.email,
      password: params.password,
      confirmPassword: params.confirmPassword,
    );

    return _authRepository.register(authEntity);
  }
}
