import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item_model.dart';
import '../core/firestore_service.dart';

class MenuItemRepository {
  final FirestoreService _firestoreService = FirestoreService();

  /// 1. Thêm MenuItem
  Future<void> addMenuItem(MenuItemModel item) async {
    await _firestoreService.menuItems.doc(item.itemId).set(item.toMap());
  }

  /// 2. Lấy MenuItem theo ID
  Future<MenuItemModel?> getMenuItemById(String itemId) async {
    final doc = await _firestoreService.menuItems.doc(itemId).get();
    if (!doc.exists) return null;
    return MenuItemModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
  }

  /// 3. Lấy tất cả MenuItems (Stream Realtime)
  Stream<List<MenuItemModel>> streamMenuItems() {
    return _firestoreService.menuItems
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItemModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    });
  }

  /// 4. Tìm kiếm MenuItems (filter ở client)
  Future<List<MenuItemModel>> searchMenuItems(String keyword) async {
    final snapshot = await _firestoreService.menuItems.get();
    final lowerKeyword = keyword.toLowerCase();

    return snapshot.docs
        .map((doc) => MenuItemModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .where((item) =>
            item.name.toLowerCase().contains(lowerKeyword) ||
            item.description.toLowerCase().contains(lowerKeyword) ||
            item.ingredients.any((i) => i.toLowerCase().contains(lowerKeyword)))
        .toList();
  }

  /// 5. Lọc theo category
  Stream<List<MenuItemModel>> filterByCategory(String category) {
    return _firestoreService.menuItems
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItemModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  /// 6. Lọc theo vegetarian
  Stream<List<MenuItemModel>> filterVegetarian(bool isVegetarian) {
    return _firestoreService.menuItems
        .where('isVegetarian', isEqualTo: isVegetarian)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItemModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }

  /// 7. Lọc theo spicy
  Stream<List<MenuItemModel>> filterSpicy(bool isSpicy) {
    return _firestoreService.menuItems
        .where('isSpicy', isEqualTo: isSpicy)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItemModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
            .toList());
  }
}
