import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/admin/presentation/state/admin_booking_detail_state.dart';
import 'package:tiffinmate/features/admin/presentation/view_model/admin_booking_detail_viewmodel.dart';

class AdminBookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const AdminBookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<AdminBookingDetailScreen> createState() => _AdminBookingDetailScreenState();
}

class _AdminBookingDetailScreenState
    extends ConsumerState<AdminBookingDetailScreen> {
  static const _statuses = <String>[
    'pending',
    'accepted',
    'dispatched',
    'delivered',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(adminBookingDetailViewModelProvider.notifier)
          .loadBooking(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminBookingDetailViewModelProvider);

    Widget buildBody() {
      switch (state.status) {
        case AdminBookingDetailStatus.initial:
        case AdminBookingDetailStatus.loading:
          return const Center(child: CircularProgressIndicator());
        case AdminBookingDetailStatus.error:
          return Center(
            child: Text(state.errorMessage ?? 'Failed to load booking detail'),
          );
        case AdminBookingDetailStatus.loaded:
        case AdminBookingDetailStatus.updating:
          final booking = state.booking;
          if (booking == null) {
            return const Center(child: Text('Booking not found'));
          }

          final isUpdating = state.status == AdminBookingDetailStatus.updating;

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
                        const SizedBox(height: 4),
                        Text('User ID: ${booking.userId ?? 'N/A'}'),
                        const SizedBox(height: 8),
                        Text('Day: ${booking.day}'),
                        Text('Time: ${booking.time}'),
                        Text('Frequency: ${booking.frequency}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Status: '),
                            DropdownButton<String>(
                              value: booking.status,
                              items: _statuses
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s),
                                    ),
                                  )
                                  .toList(),
                              onChanged: isUpdating
                                  ? null
                                  : (value) async {
                                      if (value == null || value == booking.status) {
                                        return;
                                      }
                                      final error = await ref
                                          .read(
                                              adminBookingDetailViewModelProvider
                                                  .notifier)
                                          .updateStatus(booking.id, value);
                                      if (error != null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(error)),
                                        );
                                      }
                                    },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isUpdating
                            ? null
                            : () async {
                                final error = await ref
                                    .read(adminBookingDetailViewModelProvider
                                        .notifier)
                                    .cancelBooking(booking.id);
                                if (error != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(error)),
                                  );
                                }
                              },
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Cancel Booking'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
                    title: Text(item.name),
                    subtitle: Text(
                        'Qty: ${item.qty} x Rs ${item.price.toStringAsFixed(1)}'),
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
        title: const Text('Booking Detail (Admin)'),
      ),
      body: buildBody(),
    );
  }
}
