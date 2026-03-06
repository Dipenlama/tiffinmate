import 'package:tiffinmate/core/api/api_endpoints.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';

class ItemApiModel {
  final String id;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final String? category;
  final bool available;
  final String createdAt;
  final String updatedAt;

  ItemApiModel({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.price,
    this.category,
    required this.available,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemApiModel.fromJson(Map<String, dynamic> json) {
    final rawImage = json['image'] as String?;

    String? resolvedImage;
    if (rawImage != null && rawImage.isNotEmpty) {
      if (rawImage.startsWith('http')) {
        resolvedImage = rawImage;
      } else {
        // Backend sends paths like "/uploads/..."; strip '/api' from baseUrl
        // to get the host origin, then append the relative image path.
        final base = ApiEndpoints.baseUrl; // e.g. http://10.0.2.2:5050/api
        final idx = base.indexOf('/api');
        final host = idx == -1 ? base : base.substring(0, idx);
        resolvedImage = '$host$rawImage';
      }
    }

    return ItemApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: resolvedImage,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String?,
      available: json['available'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  ItemEntity toEntity() {
    return ItemEntity(
      id: id,
      name: name,
      description: description,
      image: image,
      price: price,
      category: category,
      isAvailable: available,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
