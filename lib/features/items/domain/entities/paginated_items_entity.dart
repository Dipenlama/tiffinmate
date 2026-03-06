import 'package:equatable/equatable.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';

class PaginatedItemsEntity extends Equatable {
  final List<ItemEntity> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PaginatedItemsEntity({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [items, total, page, limit, totalPages];
}
