import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/admin/domain/usecases/create_admin_user_usecase.dart';
import 'package:tiffinmate/features/admin/domain/usecases/delete_admin_user_usecase.dart';
import 'package:tiffinmate/features/admin/domain/usecases/get_admin_users_usecase.dart';
import 'package:tiffinmate/features/admin/domain/usecases/update_admin_user_usecase.dart';
import 'package:tiffinmate/features/admin/presentation/state/admin_users_list_state.dart';

final adminUsersListViewModelProvider =
    NotifierProvider<AdminUsersListViewModel, AdminUsersListState>(
  AdminUsersListViewModel.new,
);

class AdminUsersListViewModel extends Notifier<AdminUsersListState> {
  late final GetAdminUsersUsecase _getAdminUsersUsecase;
  late final CreateAdminUserUsecase _createAdminUserUsecase;
  late final UpdateAdminUserUsecase _updateAdminUserUsecase;
  late final DeleteAdminUserUsecase _deleteAdminUserUsecase;

  @override
  AdminUsersListState build() {
    _getAdminUsersUsecase = ref.read(getAdminUsersUsecaseProvider);
    _createAdminUserUsecase = ref.read(createAdminUserUsecaseProvider);
    _updateAdminUserUsecase = ref.read(updateAdminUserUsecaseProvider);
    _deleteAdminUserUsecase = ref.read(deleteAdminUserUsecaseProvider);
    return const AdminUsersListState();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(status: AdminUsersListStatus.loading, page: 1);
    final result = await _getAdminUsersUsecase(
      const GetAdminUsersParams(page: 1, limit: 10),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AdminUsersListStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: AdminUsersListStatus.loaded,
        users: data.users,
        page: data.page,
        totalPages: data.totalPages,
        errorMessage: null,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.status == AdminUsersListStatus.loadingMore ||
        state.page >= state.totalPages) {
      return;
    }

    state = state.copyWith(status: AdminUsersListStatus.loadingMore);

    final nextPage = state.page + 1;
    final result = await _getAdminUsersUsecase(
      GetAdminUsersParams(page: nextPage, limit: 10),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AdminUsersListStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: AdminUsersListStatus.loaded,
        users: [...state.users, ...data.users],
        page: data.page,
        totalPages: data.totalPages,
        errorMessage: null,
      ),
    );
  }

  Future<String?> createUser({
    required String email,
    required String username,
    required String password,
    String? confirmPassword,
  }) async {
    final result = await _createAdminUserUsecase(
      CreateAdminUserParams(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    return result.fold(
      (failure) => failure.message,
      (_) {
        // Reload first page after successful create
        loadInitial();
        return null;
      },
    );
  }

  Future<String?> updateUser({
    required String id,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
  }) async {
    final result = await _updateAdminUserUsecase(
      UpdateAdminUserParams(
        id: id,
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );

    return result.fold(
      (failure) => failure.message,
      (_) {
        loadInitial();
        return null;
      },
    );
  }

  Future<String?> deleteUser(String id) async {
    final result = await _deleteAdminUserUsecase(
      DeleteAdminUserParams(id: id),
    );

    return result.fold(
      (failure) => failure.message,
      (_) {
        loadInitial();
        return null;
      },
    );
  }
}
