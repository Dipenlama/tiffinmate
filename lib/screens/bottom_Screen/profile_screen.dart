import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/core/services/storage/user_session.dart';
import 'package:tiffinmate/features/auth/presentation/state/auth_state.dart';
import 'package:tiffinmate/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:tiffinmate/features/admin/presentation/pages/admin_dashboard_screen.dart';
import 'package:tiffinmate/screens/account_details_screen.dart';
import 'package:tiffinmate/screens/change_password_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _handleLogout() async {
    await ref.read(authViewModelProvider.notifier).logout();

    final authState = ref.read(authViewModelProvider);

    if (authState.status == AuthStatus.unauthenticated) {
      await ref.read(userSessionServiceProvider).clearUserSession();

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else if (authState.status == AuthStatus.error && authState.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final userSession = ref.watch(userSessionServiceProvider);

    final username = authState.user?.username ?? userSession.getFullName() ?? 'Guest User';
    final email = authState.user?.email ?? userSession.getUserEmail() ?? 'Email not available';
    final role = authState.user?.role ?? userSession.getUserRole() ?? 'user';
    final isAdmin = role == 'admin';

    final initials = username.isNotEmpty
        ? username
            .trim()
            .split(RegExp(r'\s+'))
            .where((part) => part.isNotEmpty)
            .map((part) => part[0].toUpperCase())
            .take(2)
            .join()
        : '?';

    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepOrange.shade400,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Account Details'),
                      subtitle: const Text('View and manage your account information'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AccountDetailsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 0),
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text('Change Password'),
                      subtitle: const Text('Update your account password'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    if (isAdmin) const Divider(height: 0),
                    if (isAdmin)
                      ListTile(
                        leading: const Icon(Icons.admin_panel_settings_outlined),
                        title: const Text('Admin Dashboard'),
                        subtitle: const Text('Access admin-only management tools'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminDashboardScreen(),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isLoading ? null : _handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.logout),
                label: Text(
                  isLoading ? 'Logging out...' : 'Logout',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}