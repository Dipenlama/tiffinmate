import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/items/presentation/view_model/items_viewmodel.dart';
import 'package:tiffinmate/features/items/presentation/state/items_state.dart';
import 'package:tiffinmate/features/items/presentation/pages/item_detail_screen.dart';

class ItemsListScreen extends ConsumerStatefulWidget {
  const ItemsListScreen({super.key});

  @override
  ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends ConsumerState<ItemsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(itemsViewModelProvider.notifier).loadItems());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                ref
                    .read(itemsViewModelProvider.notifier)
                    .loadItems(query: value.trim());
              },
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                switch (state.status) {
                  case ItemsStatus.initial:
                  case ItemsStatus.loading:
                    return const Center(child: CircularProgressIndicator());
                  case ItemsStatus.error:
                    return Center(
                      child: Text(state.errorMessage ?? 'Failed to load items'),
                    );
                  case ItemsStatus.loaded:
                    if (state.items.isEmpty) {
                      return const Center(child: Text('No items found'));
                    }
                    return ListView.separated(
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return ListTile(
                          leading: const Icon(Icons.restaurant_menu),
                          title: Text(item.name),
                          subtitle: Text(
                            item.description ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text('Rs ${item.price.toStringAsFixed(1)}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ItemDetailScreen(item: item),
                              ),
                            );
                          },
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
