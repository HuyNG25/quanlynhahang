import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/cart_provider.dart';
import '../../repositories/reservation_repository.dart';

class CreateReservationScreen extends StatefulWidget {
  const CreateReservationScreen({super.key});

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  DateTime? selectedDateTime;
  int numberOfGuests = 1;
  final noteCtrl = TextEditingController();

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: DateTime.now(),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final repo = context.read<ReservationRepository>();
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Đặt bàn')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(
                selectedDateTime != null
                    ? selectedDateTime.toString()
                    : 'Chọn ngày & giờ',
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: _pickDateTime,
            ),

            Row(
              children: [
                const Text('Số khách'),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (numberOfGuests > 1) {
                      setState(() => numberOfGuests--);
                    }
                  },
                ),
                Text(numberOfGuests.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() => numberOfGuests++);
                  },
                ),
              ],
            ),

            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(labelText: 'Ghi chú'),
            ),

            const Divider(),

            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('Giỏ hàng trống'))
                  : ListView(
                      children: cart.items.values.map((e) {
                        final item = e.item;
                        final quantity = e.quantity ?? 0;
                        final price = item.price ?? 0.0;
                        return ListTile(
                          title: Text(item.name ?? 'Unknown'),
                          trailing: Text('$quantity x ${price.toStringAsFixed(0)} đ'),
                        );
                      }).toList(),
                    ),
            ),

            Text(
              'Tổng tiền: ${cart.total?.toStringAsFixed(0) ?? 0} đ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedDateTime == null ||
                        cart.items.isEmpty ||
                        userId == null)
                    ? null
                    : () async {
                        try {
                          await repo.createReservation(
                            customerId: userId,
                            reservationDate: selectedDateTime!,
                            numberOfGuests: numberOfGuests,
                            specialRequests: noteCtrl.text,
                            cart: cart,
                          );

                          cart.clear();

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đặt bàn thất bại: $e')),
                          );
                        }
                      },
                child: const Text('Xác nhận'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
