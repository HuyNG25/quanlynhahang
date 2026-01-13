import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/menu_item_model.dart';
import '../../providers/cart_provider.dart';

class MenuDetailScreen extends StatelessWidget {
  final MenuItemModel item;

  const MenuDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                if (item.isVegetarian)
                  const Icon(Icons.eco, color: Colors.green),
                if (item.isSpicy)
                  const Icon(Icons.local_fire_department,
                      color: Colors.red),
              ],
            ),

            const SizedBox(height: 8),
            Text(item.description),
            const SizedBox(height: 8),

            Text(
              'Giá: ${item.price.toStringAsFixed(0)} đ',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            Text('Danh mục: ${item.category}'),
            Text('Thời gian chế biến: ${item.preparationTime} phút'),
            Text('Đánh giá: ⭐ ${item.rating}'),

            const Divider(height: 32),

            const Text(
              'Nguyên liệu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...item.ingredients.map((i) => Text('• $i')),

            const SizedBox(height: 32),

            if (!item.isAvailable)
              const Center(
                child: Text(
                  'HẾT MÓN',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    cart.addItem(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Đã thêm vào đơn')),
                    );
                  },
                  child: const Text('Thêm vào đơn'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
