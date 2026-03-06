import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/bookings/presentation/state/bookings_list_state.dart';
import 'package:tiffinmate/features/bookings/presentation/view_model/bookings_list_viewmodel.dart';
import 'package:tiffinmate/features/bookings/presentation/pages/booking_detail_screen.dart';
import 'package:tiffinmate/features/items/domain/usecases/get_item_detail_usecase.dart';

class BookingsListScreen extends ConsumerStatefulWidget {
  const BookingsListScreen({super.key});

  @override
  ConsumerState<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends ConsumerState<BookingsListScreen> {
  final Map<String, String?> _itemImageCache = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bookingsListViewModelProvider.notifier).loadInitial(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingsListViewModelProvider);
    final hasMore = state.page < state.totalPages;

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
        case BookingsStatus.initial:
        case BookingsStatus.loading:
          return const Center(child: CircularProgressIndicator());
        case BookingsStatus.error:
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.errorMessage ?? 'Failed to load bookings'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(bookingsListViewModelProvider.notifier)
                        .loadInitial();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        case BookingsStatus.loaded:
        case BookingsStatus.loadingMore:
          if (state.bookings.isEmpty) {
            return const Center(
              child: Text('No bookings yet. Start by booking a meal!'),
            );
          }

          return ListView.builder(
            itemCount: state.bookings.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.bookings.length) {
                // Load more row
                if (state.status == BookingsStatus.loadingMore) {
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
                            .read(bookingsListViewModelProvider.notifier)
                            .loadMore();
                      },
                      child: const Text('Load more'),
                    ),
                  ),
                );
              }

              final booking = state.bookings[index];
              final items = booking.items;
              final firstItemName = items.isNotEmpty ? items.first.name : 'No items';
              final extraCount = items.length > 1 ? items.length - 1 : 0;
              final subtitleParts = <String>[
                'Day: ${booking.day} at ${booking.time}',
                'Status: ${booking.status}',
              ];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: items.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 48,
                            width: 48,
                            child: FutureBuilder<String?>(
                              future: _getOrFetchItemImage(items.first.id),
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
                        )
                      : const Icon(Icons.restaurant_menu),
                  title: Text(
                    extraCount > 0
                        ? '$firstItemName + $extraCount more'
                        : firstItemName,
                  ),
                  subtitle: Text(subtitleParts.join(' \u2022 ')),
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
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingDetailScreen(
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
        title: const Text('My Bookings'),
      ),
      body: buildBody(),
    );
  }
}
