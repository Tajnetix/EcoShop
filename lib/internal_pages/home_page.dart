import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dashboard_page.dart';
import 'category_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';
import 'message_page.dart';
import '../all_categories_pages/product_details_page.dart';
import 'image_search_page.dart';

import '../services/cart_service.dart';
import '../models/cart_item.dart';
import 'cart_page.dart';
import '../services/favorite_service.dart';
import '../models/favorite_model.dart';

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
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  int cartCount = 0;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRandomProducts();
    cartCount = CartService().totalItems;
  }

  Future<void> fetchRandomProducts() async {
    try {
      final data = await supabase.from('products').select().limit(50);
      data.shuffle();

      setState(() {
        products = List<Map<String, dynamic>>.from(data.take(10));
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      fetchRandomProducts();
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await supabase
          .from('products')
          .select()
          .ilike('name', '%$query%');

      setState(() {
        products = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _openPage(String title) {
    if (title == "Image Search") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ImageSearchPage()),
      );
      return;
    }

    if (title == "Dashboard") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
      return;
    }

    if (title == "Chat") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MessagePage()),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderPage(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications,
                color: Color(0xFF1B5E20)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart,
                    color: Color(0xFF1B5E20)),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );

                  setState(() {
                    cartCount = CartService().totalItems;
                  });
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SEARCH BAR
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE3EFE4),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: searchProducts,
                decoration: const InputDecoration(
                  hintText: 'Search eco-friendly products...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // BANNER BUTTONS
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

            const SizedBox(height: 20),

            const Text(
              "Our Products",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (_, index) {
                      final product = products[index];

return _productCard(
  name: product['name'] ?? '',
  price: product['price']?.toDouble() ?? 0.0,
  imageUrl: product['image_url'] ?? '',
  onAddToCart: () {
    CartService().addToCart(
      CartItem(
        id: product['id'].toString(),
        name: product['name'],
        price: product['price'].toDouble(),
        imageUrl: product['image_url'],
      ),
    );

    setState(() {
      cartCount = CartService().totalItems;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product['name']} added to cart")),
    );
  },
  onFavorite: () async {
  final item = FavoriteItem(
    id: '',
    productId: product['id'].toString(),
    name: product['name'],
    price: product['price'].toDouble(),
    imageUrl: product['image_url'],
  );

  await FavoriteService().addToFavorite(item);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Added to favorites")),
  );
},
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsPage(
          productId: product['id'],
          origin: 'home',
        ),
      ),
    );
  },
);
                    },
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

  static Widget _productCard({
    required String name,
    required double price,
    required String imageUrl,
    required VoidCallback onAddToCart,
    required VoidCallback onFavorite,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 50),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text("\$$price",
                      style: const TextStyle(
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: Color(0xFF1B5E20)),
                        onPressed: onFavorite,
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart,
                            color: Color(0xFF1B5E20)),
                        onPressed: onAddToCart,
                      ),
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