import 'package:flutter/material.dart';
import 'category_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';
import 'dashboard_page.dart';

void main() {
  runApp(const EcoShopApp());
}

class EcoShopApp extends StatelessWidget {
  const EcoShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/* ================= HOME PAGE ================= */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int bottomIndex = 0;

  final pages = const [
    HomeTab(),
    CategoryPage(),
    FavoritePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[bottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomIndex,
        onTap: (i) => setState(() => bottomIndex = i),
        selectedItemColor: const Color(0xFF1B5E20),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/* ================= HOME TAB ================= */

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedCategory = 0;
  final ScrollController _chipScrollController = ScrollController();

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.grid_view, 'title': 'All'},
    {'icon': Icons.restaurant, 'title': 'Food & Sweeteners'},
    {'icon': Icons.kitchen, 'title': 'Kitchen'},
    {'icon': Icons.shopping_bag, 'title': 'Bags & Packaging'},
    {'icon': Icons.spa, 'title': 'Body Care'},
    {'icon': Icons.eco, 'title': 'Eco Home'},
  ];

  @override
  void dispose() {
    _chipScrollController.dispose();
    super.dispose();
  }

  void _openPage(String title) {
    // ✅ Open real dashboard
    if (title == "Dashboard") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        ),
      );
      return;
    }

    // Other pages still placeholder
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceholderPage(title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F0),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'EcoShop',
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /* ===== SEARCH ===== */
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE3EFE4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search eco-friendly products...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /* ===== BANNER BUTTONS ===== */
            Row(
              children: [
                Expanded(
                  child: _bannerBtn(
                    icon: Icons.camera_alt,
                    text: "Image Search",
                    onTap: () => _openPage("Image Search"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _bannerBtn(
                    icon: Icons.dashboard,
                    text: "Dashboard",
                    onTap: () => _openPage("Dashboard"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _bannerBtn(
                    icon: Icons.chat,
                    text: "Chat",
                    onTap: () => _openPage("Chat"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /* ===== CATEGORY CHIPS ===== */
            SizedBox(
              height: 52,
              child: ListView.builder(
                controller: _chipScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, i) {
                  final bool selected = selectedCategory == i;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedCategory = i);
                      _openPage(categories[i]['title']);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF1B5E20) : Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFF1B5E20)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            categories[i]['icon'],
                            size: 18,
                            color: selected ? Colors.white : const Color(0xFF1B5E20),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            categories[i]['title'],
                            style: TextStyle(
                              fontSize: 13,
                              color: selected ? Colors.white : const Color(0xFF1B5E20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "6 Products",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (_, __) => _productCard(),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _bannerBtn({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1B5E20)),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  static Widget _productCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

/* ================= PLACEHOLDER ================= */

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title Page', style: const TextStyle(fontSize: 22)),
      ),
    );
  }
}
