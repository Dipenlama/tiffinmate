import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_users_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/entities/paginated_admin_users_entity.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_users_repository.dart';

class GetAdminUsersParams extends Equatable {
  final int page;
  final int limit;

  const GetAdminUsersParams({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

final getAdminUsersUsecaseProvider = Provider<GetAdminUsersUsecase>((ref) {
  final repo = ref.read(adminUsersRepositoryProvider);
  return GetAdminUsersUsecase(repository: repo);
});

class GetAdminUsersUsecase
    implements UsecaseWithParms<PaginatedAdminUsersEntity, GetAdminUsersParams> {
  final IAdminUsersRepository _repository;

  GetAdminUsersUsecase({required IAdminUsersRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, PaginatedAdminUsersEntity>> call(
    GetAdminUsersParams params,
  ) {
    return _repository.getUsers(page: params.page, limit: params.limit);
  }
}
