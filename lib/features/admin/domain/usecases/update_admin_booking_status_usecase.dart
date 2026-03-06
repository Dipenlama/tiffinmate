import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_bookings_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_bookings_repository.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';

class UpdateAdminBookingStatusParams extends Equatable {
  final String id;
  final String status;

  const UpdateAdminBookingStatusParams({required this.id, required this.status});

  @override
  List<Object?> get props => [id, status];
}

final updateAdminBookingStatusUsecaseProvider =
    Provider<UpdateAdminBookingStatusUsecase>((ref) {
  final repo = ref.read(adminBookingsRepositoryProvider);
  return UpdateAdminBookingStatusUsecase(repository: repo);
});

class UpdateAdminBookingStatusUsecase
    implements UsecaseWithParms<BookingEntity, UpdateAdminBookingStatusParams> {
  final IAdminBookingsRepository _repository;

  UpdateAdminBookingStatusUsecase({required IAdminBookingsRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, BookingEntity>> call(
    UpdateAdminBookingStatusParams params,
  ) {
    return _repository.updateStatus(params.id, params.status);
  }
}
