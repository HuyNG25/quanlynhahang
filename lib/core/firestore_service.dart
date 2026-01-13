import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy instance của các collection
  CollectionReference get customers => _db.collection('customers');
  CollectionReference get menuItems => _db.collection('menu_items');
  CollectionReference get reservations => _db.collection('reservations');
}