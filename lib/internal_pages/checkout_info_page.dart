import 'package:flutter/material.dart';
import 'payment_page.dart';

class CheckoutInfoPage extends StatelessWidget {
  const CheckoutInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE8D3),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ===== STEP INDICATOR =====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF1B5E20),
                  child: Text("1",
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Text("Info"),
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey,
                  child: Text("2",
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Text("Payment"),
              ],
            ),

            const SizedBox(height: 20),

            // ===== PERSONAL INFO =====
            _cardSection(
              title: "Personal Information",
              child: Column(
                children: const [
                  _InputField("Full Name"),
                  _InputField("Email"),
                  _InputField("Phone"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== ADDRESS =====
            _cardSection(
              title: "Shipping Address",
              child: Column(
                children: const [
                  _InputField("Street Address"),
                  _InputField("City"),
                  _InputField("State"),
                  _InputField("ZIP Code"),
                  _InputField("Country"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== CONTINUE BUTTON =====
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentPage(),
                    ),
                  );
                },

                child: const Text(
                  "Continue to Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== CARD UI =====
  static Widget _cardSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ===== INPUT FIELD =====
class _InputField extends StatelessWidget {
  final String hint;
  const _InputField(this.hint);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF2F6F0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}