import 'package:flutter/material.dart';
import '../models/menu_item_model.dart';
import '../screens/menu/menu_detail_screen.dart';

class MenuCard extends StatelessWidget {
  final MenuItemModel item;

  const MenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MenuDetailScreen(item: item),
          ),
        );
      },
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.network(
                    item.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (!item.isAvailable)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        color: Colors.red,
                        child: const Text(
                          'Hết món',
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('${item.price.toStringAsFixed(0)} đ'),
                  Row(
                    children: [
                      if (item.isVegetarian)
                        const Icon(Icons.eco,
                            color: Colors.green, size: 16),
                      if (item.isSpicy)
                        const Icon(Icons.local_fire_department,
                            color: Colors.red, size: 16),
                      const Spacer(),
                      Text('⭐ ${item.rating}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
