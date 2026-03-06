import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_bookings_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_bookings_repository.dart';
import 'package:tiffinmate/features/bookings/domain/entities/paginated_bookings_entity.dart';

class GetAdminBookingsParams extends Equatable {
  final int page;
  final int limit;

  const GetAdminBookingsParams({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

final getAdminBookingsUsecaseProvider = Provider<GetAdminBookingsUsecase>((ref) {
  final repo = ref.read(adminBookingsRepositoryProvider);
  return GetAdminBookingsUsecase(repository: repo);
});

class GetAdminBookingsUsecase
    implements UsecaseWithParms<PaginatedBookingsEntity, GetAdminBookingsParams> {
  final IAdminBookingsRepository _repository;

  GetAdminBookingsUsecase({required IAdminBookingsRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, PaginatedBookingsEntity>> call(
    GetAdminBookingsParams params,
  ) {
    return _repository.getBookings(page: params.page, limit: params.limit);
  }
}
