import 'package:dartz/dartz.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/features/auth/domain/entities/auth_entity.dart';


abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> getCurrentUser(String authId);
  Future<Either<Failure, bool>> logout();
}
