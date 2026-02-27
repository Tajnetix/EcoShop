import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import 'checkout_info_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = CartService();

  @override
  Widget build(BuildContext context) {
    final items = cart.items;
    double subtotal = cart.totalPrice;
    double shipping = 50;
    double total = subtotal + shipping;

    return Scaffold(
      backgroundColor: const Color(0xFFDDE8D3),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Cart", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: items.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [

                /// 🛒 PRODUCT LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Row(
                          children: [

                            /// 🖼 IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// 📦 NAME + PRICE
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text("৳${item.price}",
                                      style: const TextStyle(
                                          color: Colors.green)),
                                ],
                              ),
                            ),

                            /// ➖ ➕ QTY CONTROL
                            Row(
                              children: [

                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      cart.decreaseQty(item);
                                    });
                                  },
                                ),

                                Text(item.quantity.toString(),
                                    style: const TextStyle(fontSize: 16)),

                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      cart.increaseQty(item);
                                    });
                                  },
                                ),
                              ],
                            ),

                            /// 🗑 DELETE
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  cart.removeFromCart(item);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// 💰 SUMMARY SECTION
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),

                  child: Column(
                    children: [

                      /// SUBTOTAL
                      _priceRow("Subtotal", subtotal),

                      /// SHIPPING
                      _priceRow("Shipping", shipping),

                      const Divider(),

                      /// TOTAL
                      _priceRow("Total", total, isBold: true),

                      const SizedBox(height: 16),

                      /// ✅ CHECKOUT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          onPressed: () {
                                     Navigator.push(
                                        context,
                                      MaterialPageRoute(
                                       builder: (_) => const CheckoutInfoPage(),
                     ),
                   );
                  },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Proceed to Checkout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// 💰 PRICE ROW WIDGET
  Widget _priceRow(String title, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text("৳${amount.toStringAsFixed(0)}",
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}