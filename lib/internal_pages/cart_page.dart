import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import 'checkout_info_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cartService = CartService();

  @override
  Widget build(BuildContext context) {
    final List<CartItem> items = cartService.cartItems;

    return Scaffold(
      backgroundColor: const Color(0xFFDDE8D3),
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: const Color(0xFF1B5E20),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final CartItem item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                              "\$${item.price.toStringAsFixed(2)} x ${item.quantity}"),
                          trailing: SizedBox(
                            width: 120,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() =>
                                        cartService.decreaseQty(item));
                                  },
                                ),
                                Text("${item.quantity}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(
                                        () => cartService.increaseQty(item));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(
                                        () => cartService.removeFromCart(item));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total + Checkout
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "\$${cartService.totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          final user =
                              Supabase.instance.client.auth.currentUser;

                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please login to complete purchase"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return; // stop checkout
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CheckoutInfoPage()),
                          );
                        },
                        child: const Text(
                          "Checkout",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}