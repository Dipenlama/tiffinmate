import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/bookings/domain/entities/paginated_bookings_entity.dart';
import 'package:tiffinmate/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:tiffinmate/features/bookings/data/repositories/bookings_repository_impl.dart';

class GetBookingsParams extends Equatable {
  final int page;
  final int limit;

  const GetBookingsParams({this.page = 1, this.limit = 10});

  @override
  List<Object?> get props => [page, limit];
}

final getBookingsUsecaseProvider = Provider<GetBookingsUsecase>((ref) {
  final repo = ref.read(bookingsRepositoryProvider);
  return GetBookingsUsecase(bookingsRepository: repo);
});

class GetBookingsUsecase
    implements UsecaseWithParms<PaginatedBookingsEntity, GetBookingsParams> {
  final IBookingsRepository _bookingsRepository;

  GetBookingsUsecase({required IBookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, PaginatedBookingsEntity>> call(
      GetBookingsParams params) {
    return _bookingsRepository.getBookings(
      page: params.page,
      limit: params.limit,
    );
  }
}
