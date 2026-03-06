import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/admin/presentation/state/admin_users_list_state.dart';
import 'package:tiffinmate/features/admin/presentation/view_model/admin_users_list_viewmodel.dart';

class AdminUsersListScreen extends ConsumerStatefulWidget {
  const AdminUsersListScreen({super.key});

  @override
  ConsumerState<AdminUsersListScreen> createState() => _AdminUsersListScreenState();
}

class _AdminUsersListScreenState extends ConsumerState<AdminUsersListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminUsersListViewModelProvider.notifier).loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUsersListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (state.status == AdminUsersListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AdminUsersListStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Failed to load users'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(adminUsersListViewModelProvider.notifier)
                          .loadInitial();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.users.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.separated(
            itemCount: state.users.length +
                (state.page < state.totalPages ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              if (index >= state.users.length) {
                if (state.status != AdminUsersListStatus.loadingMore) {
                  ref
                      .read(adminUsersListViewModelProvider.notifier)
                      .loadMore();
                }
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final user = state.users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                  ),
                ),
                title: Text(user.username),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.role,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showUserDialog(context, userId: user.id, initialEmail: user.email, initialUsername: user.username),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _confirmDelete(context, user.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showUserDialog(
    BuildContext context, {
    String? userId,
    String? initialEmail,
    String? initialUsername,
  }) async {
    final emailController = TextEditingController(text: initialEmail ?? '');
    final usernameController = TextEditingController(text: initialUsername ?? '');
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final isEditing = userId != null;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEditing ? 'Update User' : 'Create User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password (leave blank to keep)'),
                  obscureText: true,
                ),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final username = usernameController.text.trim();
                final password = passwordController.text.trim();
                final confirmPassword = confirmPasswordController.text.trim();

                if (email.isEmpty || username.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email and username are required')),
                  );
                  return;
                }

                String? error;
                if (isEditing) {
                  error = await ref
                      .read(adminUsersListViewModelProvider.notifier)
                      .updateUser(
                        id: userId!,
                        email: email,
                        username: username,
                        password: password.isEmpty ? null : password,
                        confirmPassword:
                            confirmPassword.isEmpty ? null : confirmPassword,
                      );
                } else {
                  if (password.isEmpty || confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password and confirm password are required for new users'),
                      ),
                    );
                    return;
                  }
                  error = await ref
                      .read(adminUsersListViewModelProvider.notifier)
                      .createUser(
                        email: email,
                        username: username,
                        password: password,
                        confirmPassword: confirmPassword,
                      );
                }

                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                } else {
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final error = await ref
          .read(adminUsersListViewModelProvider.notifier)
          .deleteUser(userId);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }
}
