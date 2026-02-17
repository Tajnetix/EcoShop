import 'package:flutter/material.dart';

/// ------------------------------
/// ORDER MODEL (Merged Here)
/// ------------------------------
class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final double co2;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.co2,
  });

  double get total => price * quantity;
}

/// ------------------------------
/// ORDER DETAILS PAGE
/// ------------------------------
class OrderDetailsPage extends StatelessWidget {
  final List<OrderItem> items;
  final String paymentMethod;
  final String cardNumber;

  const OrderDetailsPage({
    super.key,
    required this.items,
    required this.paymentMethod,
    required this.cardNumber,
  });

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.total);

  double get shipping => 5.0;

  double get total => subtotal + shipping;

  double get totalCO2 =>
      items.fold(0, (sum, item) => sum + (item.co2 * item.quantity));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F7F2),
        elevation: 0,
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ---------------- ORDER SUMMARY ----------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Order Summary",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  ...items.map((item) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${item.name} x${item.quantity}",
                                style: const TextStyle(
                                    fontSize: 14),
                              ),
                            ),
                            Text(
                              "\$${item.total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w500),
                            ),
                          ],
                        ),
                      )),

                  const Divider(height: 30),

                  _priceRow("Subtotal",
                      "\$${subtotal.toStringAsFixed(2)}"),
                  _priceRow("Shipping",
                      "\$${shipping.toStringAsFixed(2)}"),

                  const Divider(height: 30),

                  _priceRow(
                    "Total",
                    "\$${total.toStringAsFixed(2)}",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ---------------- CO2 SAVED ----------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE6F4EA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.eco,
                      color: Colors.green),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      "CO₂ Saved from this Order",
                      style: TextStyle(
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    "${totalCO2.toStringAsFixed(0)}g CO₂",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ---------------- PAYMENT INFO ----------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Payment Info",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Text(
                          paymentMethod.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight:
                                  FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}",
                        style: const TextStyle(
                            fontWeight:
                                FontWeight.w500),
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

  /// Card Decoration
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(.1),
          blurRadius: 8,
          spreadRadius: 2,
        )
      ],
    );
  }

  /// Price Row
  Widget _priceRow(String title, String price,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.w400,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
