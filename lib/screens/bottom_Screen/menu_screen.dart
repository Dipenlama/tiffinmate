import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/menu/data/menu_repository.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyMenuAsync = ref.watch(weeklyMenuProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: weeklyMenuAsync.when(
        data: (weeklyMenu) {
          final todaySpecial = weeklyMenu.take(3).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _MenuSection(
                title: "Today's Special",
                items: [
                  for (final item in todaySpecial)
                    "${item.title} - Rs ${item.price.toStringAsFixed(1)}",
                ],
              ),
              const SizedBox(height: 16),
              _MenuSection(
                title: 'All Dishes',
                items: [
                  for (final item in weeklyMenu)
                    "${item.title} • ${item.category}",
                ],
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => const Center(
          child: Text('Failed to load menu'),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _MenuSection({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 18, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
