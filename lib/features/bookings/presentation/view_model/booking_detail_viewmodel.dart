import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/bookings/domain/usecases/get_booking_detail_usecase.dart';
import 'package:tiffinmate/features/bookings/presentation/state/booking_detail_state.dart';

final bookingDetailViewModelProvider =
    NotifierProvider<BookingDetailViewModel, BookingDetailState>(
        BookingDetailViewModel.new);

class BookingDetailViewModel extends Notifier<BookingDetailState> {
  late final GetBookingDetailUsecase _getBookingDetailUsecase;

  @override
  BookingDetailState build() {
    _getBookingDetailUsecase = ref.read(getBookingDetailUsecaseProvider);
    return const BookingDetailState();
  }

  Future<void> loadBooking(String id) async {
    state = state.copyWith(
      status: BookingDetailStatus.loading,
      errorMessage: null,
    );

    final result = await _getBookingDetailUsecase(
      GetBookingDetailParams(id),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingDetailStatus.error,
        errorMessage: failure.message,
      ),
      (booking) => state = state.copyWith(
        status: BookingDetailStatus.loaded,
        booking: booking,
      ),
    );
  }
}
