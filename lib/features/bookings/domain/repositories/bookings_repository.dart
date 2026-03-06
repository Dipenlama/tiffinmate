import 'package:dartz/dartz.dart';
import 'package:tiffinmate/core/error/failures.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:tiffinmate/features/bookings/domain/entities/paginated_bookings_entity.dart';

abstract interface class IBookingsRepository {
  Future<Either<Failure, BookingEntity>> createBooking({
    required List<BookingItemForCreate> items,
    required double total,
    required String day,
    required String time,
    required String frequency,
    String? draftId,
    String? package,
    String? packageName,
    String? address,
    String? notes,
  });

  Future<Either<Failure, PaginatedBookingsEntity>> getBookings({
    int page,
    int limit,
  });

  Future<Either<Failure, BookingEntity>> getBookingDetail(String id);
}

class BookingItemForCreate {
  final String id;
  final String name;
  final int qty;
  final double price;
  final double subtotal;

  BookingItemForCreate({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.subtotal,
  });
}
