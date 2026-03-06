import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/items/domain/usecases/get_items_usecase.dart';
import 'package:tiffinmate/features/items/presentation/state/items_state.dart';

final itemsViewModelProvider =
    NotifierProvider<ItemsViewModel, ItemsState>(ItemsViewModel.new);

class ItemsViewModel extends Notifier<ItemsState> {
  late final GetItemsUsecase _getItemsUsecase;

  @override
  ItemsState build() {
    _getItemsUsecase = ref.read(getItemsUsecaseProvider);
    return const ItemsState();
  }

  Future<void> loadItems({String? query}) async {
    state = state.copyWith(status: ItemsStatus.loading, query: query, errorMessage: null);

    final result = await _getItemsUsecase(
      GetItemsParams(page: 1, limit: 20, query: query),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemsStatus.error,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: ItemsStatus.loaded,
        items: data.items,
        page: data.page,
        totalPages: data.totalPages,
      ),
    );
  }
}
