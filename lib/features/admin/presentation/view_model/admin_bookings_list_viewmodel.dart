import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/admin/domain/usecases/get_admin_bookings_usecase.dart';
import 'package:tiffinmate/features/admin/presentation/state/admin_bookings_list_state.dart';

final adminBookingsListViewModelProvider =
    NotifierProvider<AdminBookingsListViewModel, AdminBookingsListState>(
  AdminBookingsListViewModel.new,
);

class AdminBookingsListViewModel extends Notifier<AdminBookingsListState> {
  late final GetAdminBookingsUsecase _getAdminBookingsUsecase;

  @override
  AdminBookingsListState build() {
    _getAdminBookingsUsecase = ref.read(getAdminBookingsUsecaseProvider);
    return const AdminBookingsListState();
  }

  Future<void> loadInitial({int limit = 10}) async {
    state = state.copyWith(
      status: AdminBookingsListStatus.loading,
      bookings: [],
      page: 1,
      totalPages: 1,
      errorMessage: null,
    );

    final result = await _getAdminBookingsUsecase(
      const GetAdminBookingsParams(page: 1, limit: 10),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AdminBookingsListStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: AdminBookingsListStatus.loaded,
        bookings: data.items,
        page: data.page,
        totalPages: data.totalPages,
      ),
    );
  }

  Future<void> loadMore({int limit = 10}) async {
    if (state.status == AdminBookingsListStatus.loadingMore) return;
    if (state.page >= state.totalPages) return;

    state = state.copyWith(status: AdminBookingsListStatus.loadingMore, errorMessage: null);

    final nextPage = state.page + 1;
    final result = await _getAdminBookingsUsecase(
      GetAdminBookingsParams(page: nextPage, limit: limit),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AdminBookingsListStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: AdminBookingsListStatus.loaded,
        bookings: [...state.bookings, ...data.items],
        page: data.page,
        totalPages: data.totalPages,
      ),
    );
  }
}
