import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';
import '../core/firestore_service.dart';

class CustomerRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// 1. Thêm Customer
  Future<void> addCustomer(CustomerModel customer) async {
    await _firestoreService.customers
        .doc(customer.customerId)
        .set(customer.toMap());
  }

  /// 2. Lấy Customer theo ID
  Future<CustomerModel?> getCustomerById(String customerId) async {
    final doc = await _firestoreService.customers
        .doc(customerId)
        .get();

    if (!doc.exists) return null;

    return CustomerModel.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>);
  }

  /// 3. Lấy tất cả Customers (real-time)
  Stream<List<CustomerModel>> getAllCustomers() {
    return _firestoreService.customers
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CustomerModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  /// 4. Cập nhật Customer
  Future<void> updateCustomer(CustomerModel customer) async {
    await _firestoreService.customers
        .doc(customer.customerId)
        .update(customer.toMap());
  }

  /// 5. Cập nhật Loyalty Points
  /// points: số điểm cộng (+) hoặc trừ (-)
  Future<void> updateLoyaltyPoints(
      String customerId, int points) async {
    final ref =
        _firestoreService.customers.doc(customerId);

    await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        final snapshot = await transaction.get(ref);
        if (!snapshot.exists) {
          throw Exception('Customer không tồn tại');
        }

        final currentPoints =
            snapshot['loyaltyPoints'] ?? 0;

        final newPoints = currentPoints + points;
        if (newPoints < 0) {
          throw Exception('Không đủ loyalty points');
        }

        transaction.update(ref, {
          'loyaltyPoints': newPoints,
        });
      },
    );
  }
}
