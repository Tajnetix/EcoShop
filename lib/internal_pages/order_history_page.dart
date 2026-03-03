import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_page.dart'; // For Purchase model

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6F0),
      appBar: AppBar(
        title: const Text(
          "Order History",
          style: TextStyle(color: Color(0xFF1B5E20)),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF1B5E20)),
      ),
      body: FutureBuilder<List<Purchase>>(
        future: fetchOrders(supabase),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(child: Text("No orders yet 🛍️"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("+${order.points} points"),
                    Text("${order.co2.toStringAsFixed(2)} kg CO₂"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Purchase>> fetchOrders(SupabaseClient supabase) async {
    final user = supabase.auth.currentUser;
    if (user == null) return [];

    final response = await supabase
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    List<Purchase> orders = [];
    for (var o in response) {
      orders.add(Purchase(
        name: o['product_name'] ?? "Product",
        points: (o['eco_points'] as num?)?.toInt() ?? 0,
        co2: (o['co2_saved'] as num?)?.toDouble() ?? 0.0,
      ));
    }

    return orders;
  }
}