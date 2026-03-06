import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tiffinmate/features/bookings/presentation/state/booking_form_state.dart';
import 'package:tiffinmate/features/bookings/presentation/view_model/booking_form_viewmodel.dart';
import 'package:tiffinmate/features/items/domain/entities/item_entity.dart';

class ItemDetailScreen extends ConsumerStatefulWidget {
  final ItemEntity item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _frequency = 'once';

  @override
  void dispose() {
    _quantityController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      _dayController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hour = picked.hour.toString().padLeft(2, '0');
      final minute = picked.minute.toString().padLeft(2, '0');
      _timeController.text = '$hour:$minute';
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
    final day = _dayController.text.trim();
    final time = _timeController.text.trim();

    final viewModel = ref.read(bookingFormViewModelProvider.notifier);

    await viewModel.createBookingForItem(
      item: widget.item,
      quantity: quantity,
      day: day,
      time: time,
      frequency: _frequency,
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      package: widget.item.category,
      packageName: widget.item.category,
    );

    final state = ref.read(bookingFormViewModelProvider);

    if (state.status == BookingFormStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking created successfully')),
      );
      Navigator.pop(context);
    } else if (state.status == BookingFormStatus.error && state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingFormViewModelProvider);
    final isSubmitting = bookingState.status == BookingFormStatus.submitting;
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.image != null && item.image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.image!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (item.category != null)
              Text(
                item.category!,
                style: const TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 8),
            Text(
              'Rs ${item.price.toStringAsFixed(1)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.description ?? 'No description available.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(
                  item.isAvailable ? Icons.check_circle : Icons.cancel,
                  color: item.isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(item.isAvailable ? 'Available' : 'Not available'),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            const Text(
              'Booking Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final v = int.tryParse(value ?? '');
                      if (v == null || v < 1) {
                        return 'Enter a valid quantity';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dayController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Day',
                      hintText: 'Select booking date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: _pickDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Time',
                      hintText: 'Select booking time',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    onTap: _pickTime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _frequency,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'once',
                        child: Text('Once'),
                      ),
                      DropdownMenuItem(
                        value: 'daily',
                        child: Text('Daily'),
                      ),
                      DropdownMenuItem(
                        value: 'weekly',
                        child: Text('Weekly'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _frequency = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Address (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: !item.isAvailable || isSubmitting
                          ? null
                          : _submitBooking,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Book Now',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
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
