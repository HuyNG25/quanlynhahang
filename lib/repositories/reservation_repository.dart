import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/firestore_service.dart';
import '../models/reservation_model.dart';
import '../models/menu_item_model.dart';
import '../providers/cart_provider.dart';

class ReservationRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* =========================================================
   * 1. TẠO ĐẶT BÀN – STATUS = pending
   * ========================================================= */
  Future<String> createReservation({
    required String customerId,
    required DateTime reservationDate,
    required int numberOfGuests,
    String? specialRequests,
    required CartProvider cart,
  }) async {
    if (cart.items.isEmpty) {
      throw Exception('Giỏ hàng trống');
    }

    double subtotal = cart.subtotal;
    double serviceCharge = subtotal * 0.1;
    double total = subtotal + serviceCharge;

    final docRef = _firestoreService.reservations.doc();

    await docRef.set({
      'reservationId': docRef.id,
      'customerId': customerId,
      'reservationDate': Timestamp.fromDate(reservationDate),
      'numberOfGuests': numberOfGuests,
      'tableNumber': null,
      'status': 'pending',
      'specialRequests': specialRequests,
      'orderItems': cart.items.values.map((c) {
        return {
          'itemId': c.item.itemId,
          'itemName': c.item.name,
          'quantity': c.quantity,
          'price': c.item.price,
        };
      }).toList(),
      'subtotal': subtotal,
      'serviceCharge': serviceCharge,
      'discount': 0.0,
      'total': total,
      'paymentMethod': null,
      'paymentStatus': 'pending',
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });

    return docRef.id;
  }

  /* =========================================================
   * 2. THÊM MÓN VÀO ĐƠN
   * ========================================================= */
  Future<void> addItemToReservation({
    required String reservationId,
    required MenuItemModel item,
    required int quantity,
  }) async {
    if (!item.isAvailable) {
      throw Exception('Món ăn đã hết');
    }

    final ref = _firestoreService.reservations.doc(reservationId);
    final snap = await ref.get();

    if (!snap.exists) throw Exception('Reservation không tồn tại');

    final data = snap.data()! as Map<String, dynamic>;
    final List<dynamic> orderItems = List.from(data['orderItems'] ?? []);

    // Kiểm tra món đã tồn tại chưa
    bool found = false;
    for (var i = 0; i < orderItems.length; i++) {
      if (orderItems[i]['itemId'] == item.itemId) {
        orderItems[i]['quantity'] += quantity;
        found = true;
        break;
      }
    }

    if (!found) {
      orderItems.add({
        'itemId': item.itemId,
        'itemName': item.name,
        'quantity': quantity,
        'price': item.price,
      });
    }

    double subtotal = 0;
    for (var e in orderItems) {
      subtotal += (e['price'] as num).toDouble() * (e['quantity'] as int);
    }

    double serviceCharge = subtotal * 0.1;
    double total = subtotal + serviceCharge;

    await ref.update({
      'orderItems': orderItems,
      'subtotal': subtotal,
      'serviceCharge': serviceCharge,
      'total': total,
      'updatedAt': Timestamp.now(),
    });
  }

  /* =========================================================
   * 3. XÁC NHẬN ĐẶT BÀN
   * ========================================================= */
  Future<void> confirmReservation({
    required String reservationId,
    required String tableNumber,
  }) async {
    await _firestoreService.reservations.doc(reservationId).update({
      'status': 'confirmed',
      'tableNumber': tableNumber,
      'updatedAt': Timestamp.now(),
    });
  }

  /* =========================================================
   * 4. THANH TOÁN
   * ========================================================= */
  Future<void> payReservation({
    required String reservationId,
    required String paymentMethod,
  }) async {
    final ref = _firestoreService.reservations.doc(reservationId);

    await _db.runTransaction((transaction) async {
      final snap = await transaction.get(ref);

      if (!snap.exists) throw Exception('Reservation không tồn tại');

      final data = snap.data()! as Map<String, dynamic>;
      final String customerId = data['customerId'] as String;
      final double total = (data['total'] as num).toDouble();

      final customerRef = _firestoreService.customers.doc(customerId);
      final customerSnap = await transaction.get(customerRef);

      int loyaltyPoints = (customerSnap['loyaltyPoints'] ?? 0) as int;

      // 1 point = 1000đ, max 50%
      double maxDiscount = total * 0.5;
      double discount = (loyaltyPoints * 1000).toDouble();
      if (discount > maxDiscount) discount = maxDiscount;

      double finalTotal = total - discount;
      int usedPoints = (discount / 1000).floor();
      int earnedPoints = (finalTotal * 0.01).floor();

      transaction.update(ref, {
        'discount': discount,
        'total': finalTotal,
        'paymentMethod': paymentMethod,
        'paymentStatus': 'paid',
        'status': 'completed',
        'updatedAt': Timestamp.now(),
      });

      transaction.update(customerRef, {
        'loyaltyPoints': loyaltyPoints - usedPoints + earnedPoints,
      });
    });
  }

  /* =========================================================
   * 5. LẤY ĐẶT BÀN
   * ========================================================= */
  Future<List<ReservationModel>> getReservationsByCustomer(String customerId) async {
    final snapshot = await _firestoreService.reservations
        .where('customerId', isEqualTo: customerId)
        .orderBy('reservationDate', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ReservationModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Future<List<ReservationModel>> getReservationsByDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final snapshot = await _firestoreService.reservations
        .where('reservationDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('reservationDate', isLessThan: Timestamp.fromDate(end))
        .get();

    return snapshot.docs
        .map((doc) => ReservationModel.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }
}
