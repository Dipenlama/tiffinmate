import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final String? category;
  final bool isAvailable;
  final String createdAt;
  final String updatedAt;

  const ItemEntity({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    this.category,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        price,
        category,
        isAvailable,
        createdAt,
        updatedAt,
      ];
}
