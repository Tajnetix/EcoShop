import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  final List<CategoryItem> categories = const [
    CategoryItem(
      title: 'Food & Natural Sweeteners',
      count: 124,
      icon: Icons.apple,
      color: Color(0xFFC8E6C9),
    ),
    CategoryItem(
      title: 'Kitchen Items',
      count: 89,
      icon: Icons.restaurant,
      color: Color(0xFFFFE0B2),
    ),
    CategoryItem(
      title: 'Plastic-Free Bags & Packaging',
      count: 67,
      icon: Icons.shopping_bag,
      color: Color(0xFFBBDEFB),
    ),
    CategoryItem(
      title: 'Natural Skin & Body Care',
      count: 156,
      icon: Icons.spa,
      color: Color(0xFFF8BBD0),
    ),
    CategoryItem(
      title: 'Home Cleaning & Household',
      count: 93,
      icon: Icons.cleaning_services,
      color: Color(0xFFB2EBF2),
    ),
    CategoryItem(
      title: 'Personal Hygiene',
      count: 71,
      icon: Icons.emoji_emotions,
      color: Color(0xFFE1BEE7),
    ),
    CategoryItem(
      title: 'Stationery & Office Items',
      count: 52,
      icon: Icons.edit,
      color: Color(0xFFFFF9C4),
    ),
    CategoryItem(
      title: 'Home Decor & Lifestyle',
      count: 78,
      icon: Icons.chair,
      color: Color(0xFFE0E0E0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCECCB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF1B5E20)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _headerBanner(),
          Expanded(child: _categoryGrid(context)),
        ],
      ),
    );
  }

  // -------- UI SECTIONS --------

  Widget _headerBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFC8E6C9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          CircleAvatar(
            backgroundColor: Color(0xFF1B5E20),
            child: Icon(Icons.eco, color: Colors.white),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Sustainable Living',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),
              Text(
                'Find eco-friendly products for every need',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _categoryGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.6,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final item = categories[index];
        return _CategoryCard(
          item: item,
          onTap: () {
            // Future: Navigate to Product List Page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${item.title} clicked')),
            );
          },
        );
      },
    );
  }
}

// -------- COMPONENTS --------

class _CategoryCard extends StatelessWidget {
  final CategoryItem item;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor: item.color,
              child: Icon(
                item.icon,
                color: const Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.count} products',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
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

// -------- DATA MODEL --------

class CategoryItem {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });
}