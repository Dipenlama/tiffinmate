import 'package:dartz/dartz.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/features/admin/domain/entities/admin_user_entity.dart';
import 'package:tiffinmate/features/admin/domain/entities/paginated_admin_users_entity.dart';

abstract class IAdminUsersRepository {
  Future<Either<Failure, PaginatedAdminUsersEntity>> getUsers({int page, int limit});
  Future<Either<Failure, AdminUserEntity>> getUser(String id);
  Future<Either<Failure, AdminUserEntity>> createUser({
    required String email,
    required String username,
    required String password,
    String? confirmPassword,
  });
  Future<Either<Failure, AdminUserEntity>> updateUser({
    required String id,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
  });
  Future<Either<Failure, Unit>> deleteUser(String id);
}
