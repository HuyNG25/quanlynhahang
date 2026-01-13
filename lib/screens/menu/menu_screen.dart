import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../repositories/menu_item_repository.dart';
import '../../models/menu_item_model.dart';
import '../../widgets/menu_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String searchText = '';
  String? selectedCategory;
  bool vegetarianOnly = false;
  bool spicyOnly = false;

  final categories = [
    'Appetizer',
    'Main Course',
    'Dessert',
    'Beverage',
    'Soup'
  ];

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MenuItemRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: StreamBuilder<List<MenuItemModel>>(
              stream: repo.streamMenuItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có món ăn'));
                }

                var items = snapshot.data!;

                // SEARCH
                if (searchText.isNotEmpty) {
                  items = items.where((item) {
                    final text = searchText.toLowerCase();
                    return item.name.toLowerCase().contains(text) ||
                        item.description.toLowerCase().contains(text) ||
                        item.ingredients.any(
                            (i) => i.toLowerCase().contains(text));
                  }).toList();
                }

                // FILTER
                if (selectedCategory != null) {
                  items = items
                      .where((item) => item.category == selectedCategory)
                      .toList();
                }

                if (vegetarianOnly) {
                  items =
                      items.where((item) => item.isVegetarian).toList();
                }

                if (spicyOnly) {
                  items = items.where((item) => item.isSpicy).toList();
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    return MenuCard(item: items[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Tìm món ăn...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() => searchText = value);
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              DropdownButton<String>(
                hint: const Text('Category'),
                value: selectedCategory,
                items: categories
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedCategory = value);
                },
              ),
              const Spacer(),
              FilterChip(
                label: const Text('Vegetarian'),
                selected: vegetarianOnly,
                onSelected: (v) {
                  setState(() => vegetarianOnly = v);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Spicy'),
                selected: spicyOnly,
                onSelected: (v) {
                  setState(() => spicyOnly = v);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
