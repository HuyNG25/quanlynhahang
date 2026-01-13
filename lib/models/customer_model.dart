import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String customerId;
  final String email;
  final String fullName;
  final String phoneNumber;
  final String address;
  final List<String> preferences;
  final int loyaltyPoints;
  final DateTime createdAt;
  final bool isActive;

  CustomerModel({
    required this.customerId,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.preferences,
    required this.loyaltyPoints,
    required this.createdAt,
    required this.isActive,
  });

  /// Firestore → Model
  factory CustomerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return CustomerModel(
      customerId: doc.id,
      email: data['email'],
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      preferences: List<String>.from(data['preferences'] ?? []),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
    );
  }

  /// Model → Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'preferences': preferences,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }
}
