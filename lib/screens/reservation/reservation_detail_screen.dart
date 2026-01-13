import 'package:flutter/material.dart';
import '../../models/reservation_model.dart';
import '../../models/order_item_model.dart';

class ReservationDetailScreen extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationDetailScreen({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    // Null-safe xử lý ngày đặt
    final date = reservation.reservationDate != null
        ? (reservation.reservationDate as dynamic).toDate()
        : null;

    // Null-safe tổng tiền
    final total = reservation.total ?? 0.0;

    // Null-safe danh sách món
    final orderItems = reservation.orderItems ?? <OrderItemModel>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đặt bàn')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ngày: ${date != null ? date.toString() : "Unknown"}'),
            Text('Số khách: ${reservation.numberOfGuests ?? 0}'),
            Text('Trạng thái: ${reservation.status ?? "Unknown"}'),

            const Divider(),

            const Text(
              'Danh sách món',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            if (orderItems.isEmpty)
              const Text('Chưa có món nào')
            else
              ...orderItems.map(
                (e) => ListTile(
                  title: Text(e.itemName ?? 'Unknown'),
                  trailing: Text(
                      '${e.quantity ?? 0} x ${e.price?.toStringAsFixed(0) ?? 0} đ'),
                ),
              ),

            const Divider(),
            Text(
              'Tổng tiền: ${total.toStringAsFixed(0)} đ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
