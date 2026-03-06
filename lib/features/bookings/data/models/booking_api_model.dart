import 'package:tiffinmate/features/bookings/domain/entities/booking_entity.dart';
import 'package:tiffinmate/features/bookings/domain/entities/booking_item_entity.dart';

class BookingItemApiModel {
  final String id;
  final String name;
  final int qty;
  final double price;
  final double subtotal;

  BookingItemApiModel({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  factory BookingItemApiModel.fromJson(Map<String, dynamic> json) {
    return BookingItemApiModel(
      id: json['id'] as String,
      name: json['name'] as String,
      qty: (json['qty'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
      'price': price,
      'subtotal': subtotal,
    };
  }

  BookingItemEntity toEntity() {
    return BookingItemEntity(
      id: id,
      name: name,
      qty: qty,
      price: price,
      subtotal: subtotal,
    );
  }
}

class BookingApiModel {
  final String id;
  final String? draftId;
  final String? userId;
  final List<BookingItemApiModel> items;
  final double total;
  final String day;
  final String time;
  final String frequency;
  final String? package;
  final String? packageName;
  final String? address;
  final String? notes;
  final String status;
  final String paymentStatus;
  final Map<String, dynamic>? meta;
  final String createdAt;
  final String updatedAt;

  BookingApiModel({
    required this.id,
    this.draftId,
    this.userId,
    required this.items,
    required this.total,
    required this.day,
    required this.time,
    required this.frequency,
    this.package,
    this.packageName,
    this.address,
    this.notes,
    required this.status,
    required this.paymentStatus,
    this.meta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingApiModel.fromJson(Map<String, dynamic> json) {
    final data = json;
    return BookingApiModel(
      id: data['_id']?.toString() ?? '',
      draftId: data['draftId'] as String?,
      userId: data['userId'] as String?,
      items: (data['items'] as List<dynamic>)
          .map((e) => BookingItemApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (data['total'] as num).toDouble(),
      day: data['day']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      frequency: data['frequency']?.toString() ?? '',
      package: data['package'] as String?,
      packageName: data['packageName'] as String?,
      address: data['address'] as String?,
      notes: data['notes'] as String?,
      status: data['status']?.toString() ?? '',
      paymentStatus: data['paymentStatus']?.toString() ?? '',
      meta: (data['meta'] as Map<String, dynamic>?),
      createdAt: data['createdAt']?.toString() ?? '',
      updatedAt: data['updatedAt']?.toString() ?? '',
    );
  }

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      draftId: draftId,
      userId: userId,
      items: items.map((e) => e.toEntity()).toList(),
      total: total,
      day: day,
      time: time,
      frequency: frequency,
      package: package,
      packageName: packageName,
      address: address,
      notes: notes,
      status: status,
      paymentStatus: paymentStatus,
      meta: meta,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
