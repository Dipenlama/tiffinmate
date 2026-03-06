import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';

enum AdminItemsListStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class AdminItemsListState extends Equatable {
  final AdminItemsListStatus status;
  final List<ItemEntity> items;
  final int page;
  final int totalPages;
  final String? errorMessage;

  const AdminItemsListState({
    this.status = AdminItemsListStatus.initial,
    this.items = const [],
    this.page = 1,
    this.totalPages = 1,
    this.errorMessage,
  });

  AdminItemsListState copyWith({
    AdminItemsListStatus? status,
    List<ItemEntity>? items,
    int? page,
    int? totalPages,
    String? errorMessage,
  }) {
    return AdminItemsListState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, page, totalPages, errorMessage];
}
