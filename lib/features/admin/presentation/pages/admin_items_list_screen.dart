import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiffinmate/features/admin/presentation/state/admin_items_list_state.dart';
import 'package:tiffinmate/features/admin/presentation/view_model/admin_items_list_viewmodel.dart';

class AdminItemsListScreen extends ConsumerStatefulWidget {
  const AdminItemsListScreen({super.key});

  @override
  ConsumerState<AdminItemsListScreen> createState() => _AdminItemsListScreenState();
}

class _AdminItemsListScreenState extends ConsumerState<AdminItemsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminItemsListViewModelProvider.notifier).loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminItemsListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Items'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (state.status == AdminItemsListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AdminItemsListStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.errorMessage ?? 'Failed to load items'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(adminItemsListViewModelProvider.notifier)
                          .loadInitial();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.items.isEmpty) {
            return const Center(child: Text('No items found'));
          }

          return ListView.separated(
            itemCount:
                state.items.length + (state.page < state.totalPages ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                if (state.status != AdminItemsListStatus.loadingMore) {
                  ref
                      .read(adminItemsListViewModelProvider.notifier)
                      .loadMore();
                }
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.items[index];
              return ListTile(
                leading: item.image != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(item.image!),
                      )
                    : const CircleAvatar(child: Icon(Icons.fastfood)),
                title: Text(item.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rs ${item.price.toStringAsFixed(2)}'),
                    if (item.category != null && item.category!.isNotEmpty)
                      Text(
                        item.category!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: item.isAvailable,
                      onChanged: (value) async {
                        final error = await ref
                            .read(adminItemsListViewModelProvider.notifier)
                            .toggleAvailability(item.id, value);
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showItemDialog(
                        context,
                        itemId: item.id,
                        initialName: item.name,
                        initialDescription: item.description,
                        initialPrice: item.price,
                        initialCategory: item.category,
                        initialImage: item.image,
                        initialAvailable: item.isAvailable,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _confirmDelete(context, item.id),
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

  Future<void> _showItemDialog(
    BuildContext context, {
    String? itemId,
    String? initialName,
    String? initialDescription,
    double? initialPrice,
    String? initialCategory,
    String? initialImage,
    bool initialAvailable = true,
  }) async {
    final nameController = TextEditingController(text: initialName ?? '');
    final descriptionController =
        TextEditingController(text: initialDescription ?? '');
    final priceController = TextEditingController(
      text: initialPrice != null ? initialPrice.toStringAsFixed(2) : '',
    );
    String? selectedCategory =
      (initialCategory != null && initialCategory.isNotEmpty)
        ? initialCategory
        : null;
    XFile? pickedImage;
    bool available = initialAvailable;

    final isEditing = itemId != null;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(isEditing ? 'Update Item' : 'Create Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration:
                          const InputDecoration(labelText: 'Category'),
                      items: const [
                        DropdownMenuItem(
                          value: 'veg',
                          child: Text('Veg'),
                        ),
                        DropdownMenuItem(
                          value: 'non veg',
                          child: Text('Non veg'),
                        ),
                        DropdownMenuItem(
                          value: 'mixed',
                          child: Text('Mixed'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final file = await picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );
                          if (file != null) {
                            setState(() {
                              pickedImage = file;
                            });
                          }
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload image from device'),
                      ),
                    ),
                    if (pickedImage != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Selected: ${pickedImage!.name}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      )
                    else if (initialImage != null && initialImage.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Current image will be kept',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Available'),
                        const Spacer(),
                        Switch(
                          value: available,
                          onChanged: (val) {
                            setState(() {
                              available = val;
                            });
                          },
                        ),
                      ],
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
                    final name = nameController.text.trim();
                    final priceText = priceController.text.trim();
                    final description = descriptionController.text.trim();
                    final category = selectedCategory;
                    final imagePath = pickedImage?.path;

                    if (name.isEmpty || priceText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Name and price are required'),
                        ),
                      );
                      return;
                    }

                    final price = double.tryParse(priceText);
                    if (price == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid price'),
                        ),
                      );
                      return;
                    }

                    String? error;
                    if (isEditing) {
                      error = await ref
                          .read(adminItemsListViewModelProvider.notifier)
                          .updateItem(
                            id: itemId!,
                            name: name,
                            description:
                                description.isEmpty ? null : description,
                            price: price,
                            category: category,
                            image: imagePath,
                            available: available,
                          );
                    } else {
                      error = await ref
                          .read(adminItemsListViewModelProvider.notifier)
                          .createItem(
                            name: name,
                            description:
                                description.isEmpty ? null : description,
                            price: price,
                            category: category,
                            image: imagePath,
                            available: available,
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
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, String itemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content:
              const Text('Are you sure you want to delete this item?'),
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
          .read(adminItemsListViewModelProvider.notifier)
          .deleteItem(itemId);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }
}
