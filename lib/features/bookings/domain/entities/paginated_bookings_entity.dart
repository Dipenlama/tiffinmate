import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';

class PaginatedBookingsEntity extends Equatable {
  final List<BookingEntity> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedBookingsEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [items, total, page, limit, totalPages];
}
