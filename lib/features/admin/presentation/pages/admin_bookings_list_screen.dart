import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/admin/presentation/state/admin_bookings_list_state.dart';
import 'package:tiffinmate/features/admin/presentation/view_model/admin_bookings_list_viewmodel.dart';
import 'package:tiffinmate/features/admin/presentation/pages/admin_booking_detail_screen.dart';

class AdminBookingsListScreen extends ConsumerStatefulWidget {
  const AdminBookingsListScreen({super.key});

  @override
  ConsumerState<AdminBookingsListScreen> createState() => _AdminBookingsListScreenState();
}

class _AdminBookingsListScreenState extends ConsumerState<AdminBookingsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminBookingsListViewModelProvider.notifier).loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminBookingsListViewModelProvider);
    final hasMore = state.page < state.totalPages;

    Widget buildBody() {
      switch (state.status) {
        case AdminBookingsListStatus.initial:
        case AdminBookingsListStatus.loading:
          return const Center(child: CircularProgressIndicator());
        case AdminBookingsListStatus.error:
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.errorMessage ?? 'Failed to load bookings'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(adminBookingsListViewModelProvider.notifier)
                        .loadInitial();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        case AdminBookingsListStatus.loaded:
        case AdminBookingsListStatus.loadingMore:
          if (state.bookings.isEmpty) {
            return const Center(
              child: Text('No bookings found'),
            );
          }

          return ListView.builder(
            itemCount: state.bookings.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.bookings.length) {
                if (state.status == AdminBookingsListStatus.loadingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(adminBookingsListViewModelProvider.notifier)
                            .loadMore();
                      },
                      child: const Text('Load more'),
                    ),
                  ),
                );
              }

              final booking = state.bookings[index];
              final items = booking.items;
              final firstItemName =
                  items.isNotEmpty ? items.first.name : 'No items';
              final extraCount = items.length > 1 ? items.length - 1 : 0;

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    extraCount > 0
                        ? '$firstItemName + $extraCount more'
                        : firstItemName,
                  ),
                  subtitle: Text(
                    'User: ${booking.userId ?? 'N/A'} • Day: ${booking.day} • ${booking.status}',
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rs ${booking.total.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.paymentStatus,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminBookingDetailScreen(
                          bookingId: booking.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bookings'),
      ),
      body: buildBody(),
    );
  }
}
