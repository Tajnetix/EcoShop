import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_details_page.dart';
import '../models/favorite_model.dart';
import '../services/favorite_service.dart';

class ProductCategoryPage extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;
  final Color backgroundColor;

  const ProductCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
    required this.backgroundColor,
  });

  @override
  State<ProductCategoryPage> createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  final supabase = Supabase.instance.client;
  final FavoriteService favoriteService = FavoriteService();

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  Set<String> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    fetchProducts();
    loadFavorites();
  }

  Future<void> fetchProducts() async {
    try {
      final data = await supabase
          .from('products')
          .select()
          .eq('category_id', widget.categoryId);

      setState(() {
        products = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      print("ERROR fetching products: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> loadFavorites() async {
    final favs = await favoriteService.getFavorites();
    setState(() {
      favoriteIds = favs.map((f) => f.productId).toSet();
    });
  }

  double getPrice(Map<String, dynamic> product) {
    final value = product['price'];
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Future<void> toggleFavorite(Map<String, dynamic> product) async {
    final productId = product['id'].toString();
    final price = getPrice(product);

    final item = FavoriteItem(
      productId: productId,
      name: product['name'] ?? '',
      price: price,
      imageUrl: product['image_url'] ?? '',
    );

    if (favoriteIds.contains(productId)) {
      await favoriteService.removeFromFavorite(productId);
      setState(() => favoriteIds.remove(productId));
    } else {
      await favoriteService.addToFavorite(item);
      setState(() => favoriteIds.add(productId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1B5E20)),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? const Center(
                  child: Text(
                    "No products found",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final productId = product['id'].toString();
                    final isFav = favoriteIds.contains(productId);
                    final price = getPrice(product);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsPage(
                              productId: product['id'],
                              origin: 'category',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      product['image_url'] ?? '',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => toggleFavorite(product),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white70,
                                        child: Icon(
                                          isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color:
                                              isFav ? const Color.fromARGB(255, 3, 177, 44) : Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'] ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "\$$price",
                                    style: const TextStyle(
                                      color: Color(0xFF1B5E20),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}