import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/bookings/presentation/state/booking_detail_state.dart';
import 'package:tiffinmate/features/bookings/presentation/view_model/booking_detail_viewmodel.dart';
import 'package:tiffinmate/features/items/domain/usecases/get_item_detail_usecase.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  final Map<String, String?> _itemImageCache = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(bookingDetailViewModelProvider.notifier)
          .loadBooking(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingDetailViewModelProvider);

    Future<String?> _getOrFetchItemImage(String itemId) async {
      if (_itemImageCache.containsKey(itemId)) {
        return _itemImageCache[itemId];
      }

      final usecase = ref.read(getItemDetailUsecaseProvider);
      final result = await usecase(GetItemDetailParams(itemId));

      return result.fold(
        (_) => null,
        (item) {
          _itemImageCache[itemId] = item.image;
          return item.image;
        },
      );
    }

    Widget buildBody() {
      switch (state.status) {
        case BookingDetailStatus.initial:
        case BookingDetailStatus.loading:
          return const Center(child: CircularProgressIndicator());
        case BookingDetailStatus.error:
          return Center(
            child: Text(state.errorMessage ?? 'Failed to load booking detail'),
          );
        case BookingDetailStatus.loaded:
          final booking = state.booking;
          if (booking == null) {
            return const Center(child: Text('Booking not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking ID: ${booking.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Day: ${booking.day}'),
                        Text('Time: ${booking.time}'),
                        Text('Frequency: ${booking.frequency}'),
                        const SizedBox(height: 8),
                        Text('Status: ${booking.status}'),
                        Text('Payment: ${booking.paymentStatus}'),
                        const SizedBox(height: 8),
                        Text(
                          'Total: Rs ${booking.total.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (booking.address != null && booking.address!.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Address',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(booking.address!),
                        ],
                      ),
                    ),
                  ),
                if (booking.notes != null && booking.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notes',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(booking.notes!),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...booking.items.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 48,
                        width: 48,
                        child: FutureBuilder<String?>(
                          future: _getOrFetchItemImage(item.id),
                          builder: (context, snapshot) {
                            final imageUrl = snapshot.data;
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container(
                                color: Colors.grey.shade200,
                              );
                            }
                            if (imageUrl != null && imageUrl.isNotEmpty) {
                              return Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              );
                            }
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.restaurant_menu, size: 20),
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(item.name),
                    subtitle:
                        Text('Qty: ${item.qty} x Rs ${item.price.toStringAsFixed(1)}'),
                    trailing: Text(
                      'Rs ${item.subtotal.toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Detail'),
      ),
      body: buildBody(),
    );
  }
}
