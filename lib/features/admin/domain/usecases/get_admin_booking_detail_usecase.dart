import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/admin/data/repositories/admin_bookings_repository_impl.dart';
import 'package:tiffinmate/features/admin/domain/repositories/admin_bookings_repository.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';

class GetAdminBookingDetailParams extends Equatable {
  final String id;

  const GetAdminBookingDetailParams(this.id);

  @override
  List<Object?> get props => [id];
}

final getAdminBookingDetailUsecaseProvider =
    Provider<GetAdminBookingDetailUsecase>((ref) {
  final repo = ref.read(adminBookingsRepositoryProvider);
  return GetAdminBookingDetailUsecase(repository: repo);
});

class GetAdminBookingDetailUsecase
    implements UsecaseWithParms<BookingEntity, GetAdminBookingDetailParams> {
  final IAdminBookingsRepository _repository;

  GetAdminBookingDetailUsecase({required IAdminBookingsRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, BookingEntity>> call(
    GetAdminBookingDetailParams params,
  ) {
    return _repository.getBooking(params.id);
  }
}
