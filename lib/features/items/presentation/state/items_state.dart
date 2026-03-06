import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';

enum ItemsStatus { initial, loading, loaded, error }

class ItemsState extends Equatable {
  final ItemsStatus status;
  final List<ItemEntity> items;
  final int page;
  final int totalPages;
  final String? query;
  final String? errorMessage;

  const ItemsState({
    this.status = ItemsStatus.initial,
    this.items = const [],
    this.page = 1,
    this.totalPages = 1,
    this.query,
    this.errorMessage,
  });

  ItemsState copyWith({
    ItemsStatus? status,
    List<ItemEntity>? items,
    int? page,
    int? totalPages,
    String? query,
    String? errorMessage,
  }) {
    return ItemsState(
      status: status ?? this.status,
      items: items ?? this.items,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, page, totalPages, query, errorMessage];
}
