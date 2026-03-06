import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/cart_service.dart';
import '../models/cart_item.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  final String origin;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    this.origin = 'home',
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? product;
  bool isLoading = true;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('id', widget.productId)
          .single();

      setState(() {
        product = response;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR fetching product: $e");
      setState(() => isLoading = false);
    }
  }

  void addToCart() {
    if (product == null) return;

    CartService().addToCart(
      CartItem(
        id: product!['id'].toString(),
        name: product!['name'],
        price: (product!['price'] as num).toDouble(),
        imageUrl: product!['image_url'],
        quantity: quantity,
        ecoPoints: (product!['eco_points'] as num?)?.toInt() ?? 0,
        co2Saved: (product!['co2_saved_per_unit'] as num?)?.toDouble() ?? 0.0,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product!['name']} added to cart"),
        backgroundColor: const Color(0xFF1B5E20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || product == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F2),
      bottomNavigationBar: _buildBottomBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              _buildBackButton(),
              const SizedBox(height: 15),
              _buildResponsiveImage(),
              const SizedBox(height: 35),
              _buildProductTitle(),
              const SizedBox(height: 8),
              _buildProductPrice(),
              const SizedBox(height: 20),
              _buildQuantitySelector(),
              const SizedBox(height: 28),
              _buildSectionTitle("Description"),
              const SizedBox(height: 8),
              _buildProductDescription(),
              const SizedBox(height: 28),
              _buildSectionTitle("Features"),
              const SizedBox(height: 12),
              ..._buildFeatures(product?['features'] ?? ""),
              const SizedBox(height: 28),
              _buildSustainableSection(
                (product?['eco_points'] ?? 0) as int,
                ((product?['co2_saved_per_unit'] ?? 0) as num).toDouble(),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, size: 24, color: Color(0xFF1B5E20)),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildResponsiveImage() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 35,
              offset: const Offset(0, 18),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.network(
            product?['image_url'] ?? '',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildProductTitle() {
    return Text(
      product?['name'] ?? '',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B3A2B),
      ),
    );
  }

  Widget _buildProductPrice() {
    return Text(
      "৳${product?['price']}",
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2E7D32),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        const Text(
          "Quantity:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                },
              ),
              Text(
                quantity.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => quantity++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B3A2B)));
  }

  Widget _buildProductDescription() {
    return Text(
      product?['description'] ?? '',
      style: const TextStyle(fontSize: 14, height: 1.5),
    );
  }

  List<Widget> _buildFeatures(String features) {
    final items = features.split(',');

    return items.map((e) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            const Icon(Icons.eco, size: 18, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                e.trim(),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildSustainableSection(int ecoPoints, double co2Saved) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3EA),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sustainable Alternative",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 6),
          Text("Replaces ${product?['alternative_of'] ?? ''}"),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _ecoBox("Eco Points", "+$ecoPoints")),
              const SizedBox(width: 14),
              Expanded(
                child: _ecoBox(
                    "CO₂ Saved", "${co2Saved.toStringAsFixed(2)} kg"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ecoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black12,
            offset: Offset(0, -2),
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B5E20),
          padding: const EdgeInsets.symmetric(vertical: 18),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onPressed: addToCart,
        child: const Text(
          "Add to Cart",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}