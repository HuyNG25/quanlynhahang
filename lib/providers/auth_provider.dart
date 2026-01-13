import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <--- import này bắt buộc
import '../models/customer_model.dart';

class AuthProvider extends ChangeNotifier {
  CustomerModel? _currentCustomer;

  CustomerModel? get currentCustomer => _currentCustomer;

  /// REGISTER
  Future<void> register({
    required String email,
    required String fullName,
    required String phoneNumber,
    required String address,
    required List<String> preferences,
  }) async {
    final customerRef =
        FirebaseFirestore.instance.collection('customers').doc();

    await customerRef.set({
      'customerId': customerRef.id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'preferences': preferences,
      'loyaltyPoints': 0,
      'createdAt': Timestamp.now(), // <--- giờ hợp lệ
      'isActive': true,
    });

    _currentCustomer = CustomerModel(
      customerId: customerRef.id,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      address: address,
      preferences: preferences,
      loyaltyPoints: 0,
      isActive: true,
      createdAt: Timestamp.now().toDate(), // <--- hợp lệ
    );

    notifyListeners();
  }

  /// LOGIN
  Future<bool> login(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('customers')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isEmpty) return false;

    final doc = snapshot.docs.first;
    _currentCustomer = CustomerModel.fromFirestore(
        doc as DocumentSnapshot<Map<String, dynamic>>);

    notifyListeners();
    return true;
  }

  /// LOGOUT
  void logout() {
    _currentCustomer = null;
    notifyListeners();
  }

  String? get currentCustomerId => _currentCustomer?.customerId;
}
