class OrderItemModel {
  final String itemId;
  final String itemName;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  double get subtotal => price * quantity;

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      itemId: map['itemId'],
      itemName: map['itemName'],
      quantity: map['quantity'],
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
    };
  }
}
