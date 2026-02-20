import 'package:flutter/material.dart';
import '../all_categories_pages/food_sweeteners_page.dart';
import '../all_categories_pages/home_decor_page.dart';
import '../all_categories_pages/skin_body_care_page.dart';
import '../all_categories_pages/hygiene_page.dart';
import '../all_categories_pages/kitchen_page.dart';
import '../all_categories_pages/bags_packaging_page.dart';
import '../all_categories_pages/stationery_page.dart';
import '../all_categories_pages/cleaning_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  final List<CategoryItem> categories = const [
    CategoryItem(
      title: 'Food & Natural Sweeteners',
      icon: Icons.apple,
      color: Color(0xFFC8E6C9),
    ),
    CategoryItem(
      title: 'Home Decor',
      icon: Icons.home,
      color: Color(0xFFFFF0B2),
    ),
    CategoryItem(
      title: 'Skin & Body Care',
      icon: Icons.spa,
      color: Color(0xFFFFCDD2),
    ),
    CategoryItem(
      title: 'Hygiene',
      icon: Icons.shower,
      color: Color(0xFFD1C4E9),
    ),
    CategoryItem(
      title: 'Kitchen',
      icon: Icons.restaurant,
      color: Color(0xFFFFE0B2),
    ),
    CategoryItem(
      title: 'Bags & Packaging',
      icon: Icons.shopping_bag,
      color: Color(0xFFBBDEFB),
    ),
    CategoryItem(
      title: 'Stationery',
      icon: Icons.menu_book,
      color: Color(0xFFB2EBF2),
    ),
    CategoryItem(
      title: 'Cleaning',
      icon: Icons.cleaning_services,
      color: Color(0xFFE0E0E0),
    ),
  ];

  void navigateToCategory(BuildContext context, String title) {
    switch (title) {
      case 'Food & Natural Sweeteners':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FoodSweetenersPage()),
        );
        break;
      case 'Home Decor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeDecorPage()),
        );
        break;
      case 'Skin & Body Care':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SkinBodyCarePage()),
        );
        break;
      case 'Hygiene':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HygienePage()),
        );
        break;
      case 'Kitchen':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const KitchenPage()),
        );
        break;
      case 'Bags & Packaging':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BagsPackagingPage()),
        );
        break;
      case 'Stationery':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StationeryPage()),
        );
        break;
      case 'Cleaning':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CleaningPage()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title page is not created yet')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return HoverCategoryBox(
                category: category,
                onTap: () => navigateToCategory(context, category.title),
              );
            },
          );
        },
      ),
    );
  }
}

class HoverCategoryBox extends StatefulWidget {
  final CategoryItem category;
  final VoidCallback onTap;

  const HoverCategoryBox({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  State<HoverCategoryBox> createState() => _HoverCategoryBoxState();
}

class _HoverCategoryBoxState extends State<HoverCategoryBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.category.color.withOpacity(0.8)
                : widget.category.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovered
                ? [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ]
                : [],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.category.icon,
                size: 40,
                color: Colors.black87,
              ),
              const SizedBox(height: 12),
              Text(
                widget.category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.title,
    required this.icon,
    required this.color,
  });
}