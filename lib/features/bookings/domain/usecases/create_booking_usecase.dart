import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/core/usecases/app_usecase.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:tiffinmate/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:tiffinmate/features/bookings/data/repositories/bookings_repository_impl.dart';

class CreateBookingParams extends Equatable {
  final List<BookingItemForCreate> items;
  final double total;
  final String day; // e.g. '2025-03-10'
  final String time; // e.g. '12:30'
  final String frequency; // 'once' | 'daily' | 'weekly'
  final String? draftId;
  final String? package;
  final String? packageName;
  final String? address;
  final String? notes;

  const CreateBookingParams({
    required this.items,
    required this.total,
    required this.day,
    required this.time,
    required this.frequency,
    this.draftId,
    this.package,
    this.packageName,
    this.address,
    this.notes,
  });

  @override
  List<Object?> get props => [
        items,
        total,
        day,
        time,
        frequency,
        draftId,
        package,
        packageName,
        address,
        notes,
      ];
}

final createBookingUsecaseProvider = Provider<CreateBookingUsecase>((ref) {
  final repo = ref.read(bookingsRepositoryProvider);
  return CreateBookingUsecase(bookingsRepository: repo);
});

class CreateBookingUsecase
    implements UsecaseWithParms<BookingEntity, CreateBookingParams> {
  final IBookingsRepository _bookingsRepository;

  CreateBookingUsecase({required IBookingsRepository bookingsRepository})
      : _bookingsRepository = bookingsRepository;

  @override
  Future<Either<Failure, BookingEntity>> call(CreateBookingParams params) {
    return _bookingsRepository.createBooking(
      items: params.items,
      total: params.total,
      day: params.day,
      time: params.time,
      frequency: params.frequency,
      draftId: params.draftId,
      package: params.package,
      packageName: params.packageName,
      address: params.address,
      notes: params.notes,
    );
  }
}
