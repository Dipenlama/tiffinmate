import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/bookings/domain/usecases/get_bookings_usecase.dart';
import 'package:tiffinmate/features/bookings/presentation/state/bookings_list_state.dart';

final bookingsListViewModelProvider =
    NotifierProvider<BookingsListViewModel, BookingsListState>(
        BookingsListViewModel.new);

class BookingsListViewModel extends Notifier<BookingsListState> {
  late final GetBookingsUsecase _getBookingsUsecase;

  @override
  BookingsListState build() {
    _getBookingsUsecase = ref.read(getBookingsUsecaseProvider);
    return const BookingsListState();
  }

  Future<void> loadInitial({int limit = 10}) async {
    state = state.copyWith(
      status: BookingsStatus.loading,
      bookings: [],
      page: 1,
      totalPages: 1,
      errorMessage: null,
    );

    final result = await _getBookingsUsecase(
      GetBookingsParams(page: 1, limit: limit),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingsStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: BookingsStatus.loaded,
        bookings: data.items,
        page: data.page,
        totalPages: data.totalPages,
      ),
    );
  }

  Future<void> loadMore({int limit = 10}) async {
    if (state.status == BookingsStatus.loadingMore) return;
    if (state.page >= state.totalPages) return;

    state = state.copyWith(status: BookingsStatus.loadingMore, errorMessage: null);

    final nextPage = state.page + 1;
    final result = await _getBookingsUsecase(
      GetBookingsParams(page: nextPage, limit: limit),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingsStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: BookingsStatus.loaded,
        bookings: [...state.bookings, ...data.items],
        page: data.page,
        totalPages: data.totalPages,
      ),
    );
  }
}
