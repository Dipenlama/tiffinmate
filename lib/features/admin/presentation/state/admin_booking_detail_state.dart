import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';

enum AdminBookingDetailStatus {
  initial,
  loading,
  loaded,
  updating,
  error,
}

class AdminBookingDetailState extends Equatable {
  final AdminBookingDetailStatus status;
  final BookingEntity? booking;
  final String? errorMessage;

  const AdminBookingDetailState({
    this.status = AdminBookingDetailStatus.initial,
    this.booking,
    this.errorMessage,
  });

  AdminBookingDetailState copyWith({
    AdminBookingDetailStatus? status,
    BookingEntity? booking,
    String? errorMessage,
  }) {
    return AdminBookingDetailState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, errorMessage];
}
