import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/admin/domain/usecases/cancel_admin_booking_usecase.dart';
import 'package:tiffinmate/features/admin/domain/usecases/get_admin_booking_detail_usecase.dart';
import 'package:tiffinmate/features/admin/domain/usecases/update_admin_booking_status_usecase.dart';
import 'package:tiffinmate/features/admin/presentation/state/admin_booking_detail_state.dart';

final adminBookingDetailViewModelProvider =
    NotifierProvider<AdminBookingDetailViewModel, AdminBookingDetailState>(
  AdminBookingDetailViewModel.new,
);

class AdminBookingDetailViewModel extends Notifier<AdminBookingDetailState> {
  late final GetAdminBookingDetailUsecase _getDetailUsecase;
  late final UpdateAdminBookingStatusUsecase _updateStatusUsecase;
  late final CancelAdminBookingUsecase _cancelBookingUsecase;

  @override
  AdminBookingDetailState build() {
    _getDetailUsecase = ref.read(getAdminBookingDetailUsecaseProvider);
    _updateStatusUsecase = ref.read(updateAdminBookingStatusUsecaseProvider);
    _cancelBookingUsecase = ref.read(cancelAdminBookingUsecaseProvider);
    return const AdminBookingDetailState();
  }

  Future<void> loadBooking(String id) async {
    state = state.copyWith(
      status: AdminBookingDetailStatus.loading,
      errorMessage: null,
    );

    final result = await _getDetailUsecase(
      GetAdminBookingDetailParams(id),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AdminBookingDetailStatus.error,
        errorMessage: failure.message,
      ),
      (booking) => state = state.copyWith(
        status: AdminBookingDetailStatus.loaded,
        booking: booking,
      ),
    );
  }

  Future<String?> updateStatus(String id, String status) async {
    state = state.copyWith(status: AdminBookingDetailStatus.updating);

    final result = await _updateStatusUsecase(
      UpdateAdminBookingStatusParams(id: id, status: status),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminBookingDetailStatus.error,
          errorMessage: failure.message,
        );
        return failure.message;
      },
      (booking) {
        state = state.copyWith(
          status: AdminBookingDetailStatus.loaded,
          booking: booking,
          errorMessage: null,
        );
        return null;
      },
    );
  }

  Future<String?> cancelBooking(String id) async {
    state = state.copyWith(status: AdminBookingDetailStatus.updating);

    final result = await _cancelBookingUsecase(
      CancelAdminBookingParams(id),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AdminBookingDetailStatus.error,
          errorMessage: failure.message,
        );
        return failure.message;
      },
      (booking) {
        state = state.copyWith(
          status: AdminBookingDetailStatus.loaded,
          booking: booking,
          errorMessage: null,
        );
        return null;
      },
    );
  }
}
