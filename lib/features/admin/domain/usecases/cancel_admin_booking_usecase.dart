import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_bookings_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_bookings_repository.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';

class CancelAdminBookingParams extends Equatable {
  final String id;

  const CancelAdminBookingParams(this.id);

  @override
  List<Object?> get props => [id];
}

final cancelAdminBookingUsecaseProvider =
    Provider<CancelAdminBookingUsecase>((ref) {
  final repo = ref.read(adminBookingsRepositoryProvider);
  return CancelAdminBookingUsecase(repository: repo);
});

class CancelAdminBookingUsecase
    implements UsecaseWithParms<BookingEntity, CancelAdminBookingParams> {
  final IAdminBookingsRepository _repository;

  CancelAdminBookingUsecase({required IAdminBookingsRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, BookingEntity>> call(
    CancelAdminBookingParams params,
  ) {
    return _repository.cancelBooking(params.id);
  }
}
