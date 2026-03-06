import 'package:equatable/equatable.dart';

class BookingItemEntity extends Equatable {
  final String id;
  final String name;
  final int qty;
  final double price;
  final double subtotal;

  const BookingItemEntity({
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [id, name, qty, price, subtotal];
}
