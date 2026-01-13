import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';

class CartItem {
  final MenuItemModel item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});

  double get subtotal => item.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  double get subtotal =>
      _items.values.fold(0, (sum, e) => sum + e.subtotal);

  double get serviceCharge => subtotal * 0.1;

  double get total => subtotal + serviceCharge;

  void addItem(MenuItemModel item) {
    final id = item.itemId; // ✅ ĐÚNG

    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
    } else {
      _items[id] = CartItem(item: item);
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (_items.containsKey(itemId)) {
      _items[itemId]!.quantity = quantity;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
