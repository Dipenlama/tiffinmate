import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_item_entity.dart';

class BookingEntity extends Equatable {
  final String id;
  final String? draftId;
  final String? userId;
  final List<BookingItemEntity> items;
  final double total;
  final String day;
  final String time;
  final String frequency;
  final String? package;
  final String? packageName;
  final String? address;
  final String? notes;
  final String status;
  final String paymentStatus;
  final Map<String, dynamic>? meta;
  final String createdAt;
  final String updatedAt;

  const BookingEntity({
    required this.id,
    this.draftId,
    this.userId,
    required this.items,
    required this.total,
    required this.day,
    required this.time,
    required this.frequency,
    this.package,
    this.packageName,
    this.address,
    this.notes,
    required this.status,
    required this.paymentStatus,
    this.meta,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        draftId,
        userId,
        items,
        total,
        day,
        time,
        frequency,
        package,
        packageName,
        address,
        notes,
        status,
        paymentStatus,
        meta,
        createdAt,
        updatedAt,
      ];
}
