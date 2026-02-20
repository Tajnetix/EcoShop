import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;
  final String origin; // <-- new field to know where it came from

  const ProductDetailsPage({
    super.key,
    required this.productId,
    this.origin = 'home', // default is home
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final supabase = Supabase.instance.client;

  Map<String, dynamic>? product;
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    final ecoPoints = ((product?['price'] ?? 0) * 4).round();
    final co2Saved = ((product?['price'] ?? 0) * 0.015).toStringAsFixed(2);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7F2),
      bottomNavigationBar: _buildBottomBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    _buildBackButton(), // <-- added back button at top
                    const SizedBox(height: 15),
                    _buildResponsiveImage(),
                    const SizedBox(height: 35),
                    _buildProductTitle(),
                    const SizedBox(height: 8),
                    _buildProductPrice(),
                    const SizedBox(height: 28),
                    _buildSectionTitle("Description"),
                    const SizedBox(height: 8),
                    _buildProductDescription(),
                    const SizedBox(height: 28),
                    _buildSectionTitle("Features"),
                    const SizedBox(height: 12),
                    ..._buildFeatures(product?['features'] ?? ""),
                    const SizedBox(height: 28),
                    _buildSustainableSection(ecoPoints, co2Saved),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
    );
  }

  /// BACK BUTTON
  Widget _buildBackButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back, size: 28, color: Color(0xFF1B5E20)),
      onPressed: () {
        if (widget.origin == 'home') {
          Navigator.pop(context); // back to home page
        } else {
          Navigator.pop(context); // for future, can handle other origins
        }
      },
    );
  }

  /// RESPONSIVE IMAGE SECTION
  Widget _buildResponsiveImage() {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double imageSize = constraints.maxWidth * 0.6;
          if (imageSize > 320) imageSize = 320;

          return Container(
            width: imageSize,
            height: imageSize,
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
          );
        },
      ),
    );
  }

  /// PRODUCT TITLE
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

  /// PRODUCT PRICE
  Widget _buildProductPrice() {
    return Text(
      "\$${product?['price']}",
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2E7D32),
      ),
    );
  }

  /// SECTION TITLE
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// PRODUCT DESCRIPTION
  Widget _buildProductDescription() {
    return Text(
      product?['description'] ?? '',
      style: const TextStyle(
        height: 1.6,
        color: Colors.black87,
      ),
    );
  }

  /// FEATURES LIST
  List<Widget> _buildFeatures(String features) {
    final items = features.split(',');

    return items.map((e) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            const Icon(
              Icons.eco,
              size: 18,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                e.trim(),
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// SUSTAINABLE SECTION
  Widget _buildSustainableSection(int ecoPoints, String co2Saved) {
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
          Text(
            "Replaces ${product?['alternative_of'] ?? ''}",
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _ecoBox("Eco Points", "+$ecoPoints")),
              const SizedBox(width: 14),
              Expanded(child: _ecoBox("CO₂ Saved", "$co2Saved kg")),
            ],
          ),
        ],
      ),
    );
  }

  /// ECO BOX WIDGET
  Widget _ecoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
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

  /// BOTTOM ADD TO CART BUTTON
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
          )
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        onPressed: () {},
        child: const Text(
          "Add to Cart",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}