import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemModel {
  final String itemId;
  final String name;
  final String description;
  final String category;
  final double price;
  final String imageUrl;
  final List<String> ingredients;
  final bool isVegetarian;
  final bool isSpicy;
  final int preparationTime;
  final bool isAvailable;
  final double rating;
  final DateTime createdAt;

  MenuItemModel({
    required this.itemId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.ingredients,
    required this.isVegetarian,
    required this.isSpicy,
    required this.preparationTime,
    required this.isAvailable,
    required this.rating,
    required this.createdAt,
  });

  factory MenuItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MenuItemModel(
      itemId: doc.id,
      name: data['name'],
      description: data['description'],
      category: data['category'],
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'],
      ingredients: List<String>.from(data['ingredients'] ?? []),
      isVegetarian: data['isVegetarian'] ?? false,
      isSpicy: data['isSpicy'] ?? false,
      preparationTime: data['preparationTime'],
      isAvailable: data['isAvailable'] ?? true,
      rating: (data['rating'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'isVegetarian': isVegetarian,
      'isSpicy': isSpicy,
      'preparationTime': preparationTime,
      'isAvailable': isAvailable,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
