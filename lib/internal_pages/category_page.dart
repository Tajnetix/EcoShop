import 'package:flutter/material.dart';
import '../all_categories_pages/product_category_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  static const List<CategoryItem> categories = [
    CategoryItem(
      title: 'Food & Natural Sweeteners',
      categoryId: 'de6dcca2-eab3-45bb-85a8-61d275fdfa96',
      icon: Icons.apple,
      color: Color(0xFFC8E6C9),
    ),
    CategoryItem(
      title: 'Home Decor',
      categoryId: '16d7dcbf-b13b-466e-ab0b-f77e322aea39',
      icon: Icons.home,
      color: Color(0xFFFFF0B2),
    ),
    CategoryItem(
      title: 'Skin & Body Care',
      categoryId: '5484e732-3955-4f46-9955-b365b36e9e5d',
      icon: Icons.spa,
      color: Color(0xFFFFCDD2),
    ),
    CategoryItem(
      title: 'Hygiene',
      categoryId: '762032e4-4ced-4aa4-a3c9-9cdbb55f7d1d',
      icon: Icons.shower,
      color: Color(0xFFD1C4E9),
    ),
    CategoryItem(
      title: 'Kitchen',
      categoryId: '8c0c1dd4-79cd-474e-b693-8deb27e7d321',
      icon: Icons.restaurant,
      color: Color(0xFFFFE0B2),
    ),
    CategoryItem(
      title: 'Bags & Packaging',
      categoryId: '973505a7-f5ab-4a1b-849c-4f61ffdf381e', 
      icon: Icons.shopping_bag,
      color: Color(0xFFDCECCB),
    ),
    CategoryItem(
      title: 'Stationery',
      categoryId: 'c7f7ad00-9f60-41a8-921f-6388f33dc1f0',
      icon: Icons.menu_book,
      color: Color(0xFFB2EBF2),
    ),
    CategoryItem(
      title: 'Cleaning',
      categoryId: 'd5e3a286-5f68-451f-9911-e5157891c017',
      icon: Icons.cleaning_services,
      color: Color(0xFFE0E0E0),
    ),
  ];

  void navigateToCategory(
    BuildContext context,
    CategoryItem category,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductCategoryPage(
          categoryId: category.categoryId,
          categoryTitle: category.title,
          backgroundColor: category.color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount =
              constraints.maxWidth < 600 ? 2 : 4;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];

              return HoverCategoryBox(
                category: category,
                onTap: () =>
                    navigateToCategory(context, category),
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
  State<HoverCategoryBox> createState() =>
      _HoverCategoryBoxState();
}

class _HoverCategoryBoxState
    extends State<HoverCategoryBox> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) =>
          setState(() => _isHovered = true),
      onExit: (_) =>
          setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.category.color
                    .withOpacity(0.85)
                : widget.category.color,
            borderRadius:
                BorderRadius.circular(16),
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
          padding:
              const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
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
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
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
  final String categoryId;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.title,
    required this.categoryId,
    required this.icon,
    required this.color,
  });
}