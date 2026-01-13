import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../repositories/reservation_repository.dart';
import '../../models/reservation_model.dart';
import 'reservation_detail_screen.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<ReservationRepository>();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Bạn chưa đăng nhập'),
        ),
      );
    }

    final userId = user.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Đặt bàn của tôi')),
      body: FutureBuilder<List<ReservationModel>>(
        future: repo.getReservationsByCustomer(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có đặt bàn'));
          }

          final list = snapshot.data!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) {
              final r = list[i];

              // Xử lý null-safe cho reservationDate
              final date = r.reservationDate != null
                  ? (r.reservationDate as dynamic).toDate()
                  : null;

              // Xử lý null-safe cho total
              final total = r.total ?? 0.0;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  title: Text(
                      'Ngày: ${date != null ? date.toString() : "Unknown"}'),
                  subtitle: Text('${r.numberOfGuests} khách - ${total.toStringAsFixed(0)} đ'),
                  trailing: Text(r.status ?? "Unknown"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ReservationDetailScreen(reservation: r),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
