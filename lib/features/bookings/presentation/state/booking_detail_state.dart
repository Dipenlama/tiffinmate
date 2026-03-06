import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';

enum BookingDetailStatus { initial, loading, loaded, error }

class BookingDetailState extends Equatable {
  final BookingDetailStatus status;
  final BookingEntity? booking;
  final String? errorMessage;

  const BookingDetailState({
    this.status = BookingDetailStatus.initial,
    this.booking,
    this.errorMessage,
  });

  BookingDetailState copyWith({
    BookingDetailStatus? status,
    BookingEntity? booking,
    String? errorMessage,
  }) {
    return BookingDetailState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, errorMessage];
}
