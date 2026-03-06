import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:tiffinmate/features/bookings/presentation/state/booking_form_state.dart';
import 'package:tiffinmate/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';

final bookingFormViewModelProvider =
    NotifierProvider<BookingFormViewModel, BookingFormState>(
        BookingFormViewModel.new);

class BookingFormViewModel extends Notifier<BookingFormState> {
  late final CreateBookingUsecase _createBookingUsecase;

  @override
  BookingFormState build() {
    _createBookingUsecase = ref.read(createBookingUsecaseProvider);
    return const BookingFormState();
  }

  Future<void> createBookingForItem({
    required ItemEntity item,
    required int quantity,
    required String day,
    required String time,
    required String frequency,
    String? address,
    String? notes,
    String? package,
    String? packageName,
  }) async {
    state = state.copyWith(status: BookingFormStatus.submitting, errorMessage: null);

    if (quantity < 1) {
      state = state.copyWith(
        status: BookingFormStatus.error,
        errorMessage: 'Quantity must be at least 1',
      );
      return;
    }

    final itemForCreate = BookingItemForCreate(
      id: item.id,
      name: item.name,
      qty: quantity,
      price: item.price,
      subtotal: item.price * quantity,
    );

    final total = itemForCreate.subtotal;

    final params = CreateBookingParams(
      items: [itemForCreate],
      total: total,
      day: day,
      time: time,
      frequency: frequency,
      address: address,
      notes: notes,
      package: package,
      packageName: packageName,
    );

    final result = await _createBookingUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: BookingFormStatus.error,
          errorMessage: failure.message,
        );
      },
      (booking) {
        state = state.copyWith(
          status: BookingFormStatus.success,
          booking: booking,
        );
      },
    );
  }

  void reset() {
    state = const BookingFormState();
  }
}
