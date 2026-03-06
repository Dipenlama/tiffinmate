import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';

enum AdminBookingsListStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class AdminBookingsListState extends Equatable {
  final AdminBookingsListStatus status;
  final List<BookingEntity> bookings;
  final int page;
  final int totalPages;
  final String? errorMessage;

  const AdminBookingsListState({
    this.status = AdminBookingsListStatus.initial,
    this.bookings = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  AdminBookingsListState copyWith({
    AdminBookingsListStatus? status,
    List<BookingEntity>? bookings,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return AdminBookingsListState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookings, page, totalPages, errorMessage];
}
