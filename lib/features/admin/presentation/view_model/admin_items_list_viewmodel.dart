import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/admin/domain/usecases/create_admin_item_usecase.dart';
import 'package:tiffinmate/features/admin/domain/usecases/delete_admin_item_usecase.dart';
import 'package:tiffinmate/features/admin/domain/usecases/get_admin_items_usecase.dart';
import 'package:tiffinmate/features/admin/domain/usecases/update_admin_item_usecase.dart';
import 'package:tiffinmate/features/admin/presentation/state/admin_items_list_state.dart';

final adminItemsListViewModelProvider =
    NotifierProvider<AdminItemsListViewModel, AdminItemsListState>(
  AdminItemsListViewModel.new,
);

class AdminItemsListViewModel extends Notifier<AdminItemsListState> {
  late final GetAdminItemsUsecase _getAdminItemsUsecase;
  late final UpdateAdminItemUsecase _updateAdminItemUsecase;
  late final CreateAdminItemUsecase _createAdminItemUsecase;
  late final DeleteAdminItemUsecase _deleteAdminItemUsecase;

  @override
  AdminItemsListState build() {
    _getAdminItemsUsecase = ref.read(getAdminItemsUsecaseProvider);
    _updateAdminItemUsecase = ref.read(updateAdminItemUsecaseProvider);
    _createAdminItemUsecase = ref.read(createAdminItemUsecaseProvider);
    _deleteAdminItemUsecase = ref.read(deleteAdminItemUsecaseProvider);
    return const AdminItemsListState();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(status: AdminItemsListStatus.loading, page: 1);
    final result = await _getAdminItemsUsecase(
      const GetAdminItemsParams(page: 1, limit: 10),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AdminItemsListStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: AdminItemsListStatus.loaded,
        items: data.items,
        page: data.page,
        totalPages: data.totalPages,
        errorMessage: null,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.status == AdminItemsListStatus.loadingMore ||
        state.page >= state.totalPages) {
      return;
    }

    state = state.copyWith(status: AdminItemsListStatus.loadingMore);

    final nextPage = state.page + 1;
    final result = await _getAdminItemsUsecase(
      GetAdminItemsParams(page: nextPage, limit: 10),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AdminItemsListStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: AdminItemsListStatus.loaded,
        items: [...state.items, ...data.items],
        page: data.page,
        totalPages: data.totalPages,
        errorMessage: null,
      ),
    );
  }

  Future<String?> toggleAvailability(String id, bool newValue) async {
    final result = await _updateAdminItemUsecase(
      UpdateAdminItemParams(id: id, available: newValue),
    );

    return result.fold(
      (failure) => failure.message,
      (_) {
        loadInitial();
        return null;
      },
    );
  }

  Future<String?> createItem({
    required String name,
    required double price,
    String? description,
    String? category,
    String? image,
    bool available = true,
  }) async {
    final result = await _createAdminItemUsecase(
      CreateAdminItemParams(
        name: name,
        description: description,
        price: price,
        category: category,
        available: available,
        image: image,
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

  Future<String?> updateItem({
    required String id,
    String? name,
    String? description,
    double? price,
    String? category,
    bool? available,
    String? image,
  }) async {
    final result = await _updateAdminItemUsecase(
      UpdateAdminItemParams(
        id: id,
        name: name,
        description: description,
        price: price,
        category: category,
        available: available,
        image: image,
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

  Future<String?> deleteItem(String id) async {
    final result = await _deleteAdminItemUsecase(
      DeleteAdminItemParams(id: id),
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
