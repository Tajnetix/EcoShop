import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cart_service.dart';
import 'dashboard_page.dart';

class PaymentPage extends StatefulWidget {
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;

  const PaymentPage({
    super.key,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final numberController = TextEditingController();
  final pinController = TextEditingController();
  final supabase = Supabase.instance.client;

  bool isProcessing = false;

  Future<void> processPayment() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please sign up to complete purchase")),
      );
      return;
    }

    if (numberController.text.length != 11 ||
        pinController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid bKash info")),
      );
      return;
    }

    setState(() => isProcessing = true);

    await Future.delayed(const Duration(seconds: 2));

    final cartItems = CartService().cartItems;

    try {
      for (var item in cartItems) {
        await supabase.from('orders').insert({
          'user_id': user.id,
          'product_id': item.id,
          'product_name': item.name,
          'quantity': item.quantity,
          'eco_points': item.ecoPoints * item.quantity,
          'co2_saved': item.co2Saved * item.quantity,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      CartService().clearCart();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
        (route) => false,
      );
    } catch (e) {
      setState(() => isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("bKash Payment"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "bKash Number",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "PIN",
              ),
            ),
            const SizedBox(height: 30),
            isProcessing
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    onPressed: processPayment,
                    child: const Text("Confirm Payment"),
                  )
          ],
        ),
      ),
    );
  }
}