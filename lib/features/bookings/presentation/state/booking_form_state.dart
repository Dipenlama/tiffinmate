import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';

enum BookingFormStatus { initial, submitting, success, error }

class BookingFormState extends Equatable {
  final BookingFormStatus status;
  final String? errorMessage;
  final BookingEntity? booking;

  const BookingFormState({
    this.status = BookingFormStatus.initial,
    this.errorMessage,
    this.booking,
  });

  BookingFormState copyWith({
    BookingFormStatus? status,
    String? errorMessage,
    BookingEntity? booking,
  }) {
    return BookingFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      booking: booking ?? this.booking,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, booking];
}
