import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:tiffinmate/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:tiffinmate/features/bookings/data/repositories/bookings_repository_impl.dart';

class GetBookingDetailParams extends Equatable {
  final String id;

  const GetBookingDetailParams(this.id);

  @override
  List<Object?> get props => [id];
}

final getBookingDetailUsecaseProvider =
    Provider<GetBookingDetailUsecase>((ref) {
  final repo = ref.read(bookingsRepositoryProvider);
  return GetBookingDetailUsecase(bookingsRepository: repo);
});

class GetBookingDetailUsecase
    implements UsecaseWithParms<BookingEntity, GetBookingDetailParams> {
  final IBookingsRepository _bookingsRepository;

  GetBookingDetailUsecase({required IBookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, BookingEntity>> call(
      GetBookingDetailParams params) {
    return _bookingsRepository.getBookingDetail(params.id);
  }
}
