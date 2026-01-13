import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_item_model.dart';

class ReservationModel {
  final String reservationId;
  final String customerId;
  final DateTime reservationDate;
  final int numberOfGuests;
  final String? tableNumber;
  final String status;
  final String? specialRequests;
  final List<OrderItemModel> orderItems;
  final double subtotal;
  final double serviceCharge;
  final double discount;
  final double total;
  final String? paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReservationModel({
    required this.reservationId,
    required this.customerId,
    required this.reservationDate,
    required this.numberOfGuests,
    this.tableNumber,
    required this.status,
    this.specialRequests,
    required this.orderItems,
    required this.subtotal,
    required this.serviceCharge,
    required this.discount,
    required this.total,
    this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReservationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ReservationModel(
      reservationId: doc.id,
      customerId: data['customerId'],
      reservationDate:
          (data['reservationDate'] as Timestamp).toDate(),
      numberOfGuests: data['numberOfGuests'],
      tableNumber: data['tableNumber'],
      status: data['status'],
      specialRequests: data['specialRequests'],
      orderItems: (data['orderItems'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromMap(e))
          .toList(),
      subtotal: (data['subtotal'] as num).toDouble(),
      serviceCharge: (data['serviceCharge'] as num).toDouble(),
      discount: (data['discount'] as num).toDouble(),
      total: (data['total'] as num).toDouble(),
      paymentMethod: data['paymentMethod'],
      paymentStatus: data['paymentStatus'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'reservationDate': Timestamp.fromDate(reservationDate),
      'numberOfGuests': numberOfGuests,
      'tableNumber': tableNumber,
      'status': status,
      'specialRequests': specialRequests,
      'orderItems': orderItems.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'serviceCharge': serviceCharge,
      'discount': discount,
      'total': total,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
