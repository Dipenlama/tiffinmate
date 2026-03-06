import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';
import 'package:tiffinmate/features/items/presentation/pages/item_detail_screen.dart';
import 'package:tiffinmate/features/items/presentation/state/items_state.dart';
import 'package:tiffinmate/features/items/presentation/view_model/items_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgcroundColor: Colors.white,
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(ion: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      //   ],
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  children: [
                    TextSpan(text: "Hey Dipen, "),
                    TextSpan(
                      text: "Good Afternoon!",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  hintText: "Search Tiffin",
                  focusedBorder: OutlineInputBorder()
                ),
                
              ),
              const SizedBox(height: 20),

              // Featured Item
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/food4.png",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "30% OFF",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 12,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chana Items",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            "Full Veg Tiffin",
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Our Menu",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(itemsViewModelProvider);

                    if (state.status == ItemsStatus.initial) {
                      Future.microtask(() =>
                          ref.read(itemsViewModelProvider.notifier).loadItems());
                    }

                    if (state.status == ItemsStatus.loading ||
                        state.status == ItemsStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == ItemsStatus.error) {
                      return Center(
                        child: Text(state.errorMessage ?? 'Failed to load items'),
                      );
                    }

                    if (state.items.isEmpty) {
                      return const Center(child: Text('No items found'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ItemDetailScreen(item: item),
                              ),
                            );
                          },
                          child: buildMenuCard(item),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuCard(ItemEntity item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: item.image != null && item.image!.isNotEmpty
                        ? Image.network(
                            item.image!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/food4.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Rs ${item.price.toStringAsFixed(1)}',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.category != null && item.category!.isNotEmpty)
                    Text(
                      item.category!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
