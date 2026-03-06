import 'package:dartz/dartz.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:tiffinmate/features/bookings/domain/entities/paginated_bookings_entity.dart';

abstract interface class IAdminBookingsRepository {
  Future<Either<Failure, PaginatedBookingsEntity>> getBookings({
    int page,
    int limit,
  });

  Future<Either<Failure, BookingEntity>> getBooking(String id);

  Future<Either<Failure, BookingEntity>> updateStatus(
    String id,
    String status,
  );

  Future<Either<Failure, BookingEntity>> cancelBooking(String id);
}
