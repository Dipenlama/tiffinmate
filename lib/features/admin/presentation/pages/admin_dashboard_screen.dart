import 'package:flutter/material.dart';
import 'package:tiffinmate/features/admin/presentation/pages/admin_items_list_screen.dart';
import 'package:tiffinmate/features/admin/presentation/pages/admin_users_list_screen.dart';
import 'package:tiffinmate/features/admin/presentation/pages/admin_bookings_list_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Admin Tools',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Manage Users'),
              subtitle: const Text('View and manage all users'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminUsersListScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Manage Items'),
              subtitle: const Text('View and manage menu items'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminItemsListScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Manage Bookings'),
              subtitle: const Text('View and manage all bookings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminBookingsListScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
