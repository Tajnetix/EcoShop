import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/cart_service.dart';
import '../../services/order_service.dart';
import '../../models/order_model.dart';
import 'home_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    double total = CartService().totalPrice + 50;

    return Scaffold(
      backgroundColor: const Color(0xFFDDE8D3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Checkout",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// STEP INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey,
                  child: Text("1",
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Text("Info"),
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF1B5E20),
                  child: Text("2",
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 8),
                Text("Payment"),
              ],
            ),

            const SizedBox(height: 30),

            /// BKASH CARD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE2136E),
                  width: 2,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance_wallet,
                      color: Color(0xFFE2136E)),
                  SizedBox(width: 10),
                  Text("bKash"),
                ],
              ),
            ),

            const Spacer(),

            /// PLACE ORDER BUTTON
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
                  _showBkashModal(context, total);
                },
                child: Text(
                  "Place Order - ৳${total.toStringAsFixed(0)}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= BKASH MODAL =================
  void _showBkashModal(BuildContext context, double total) {
    int step = 1;
    String phone = "";

    final List<TextEditingController> pinControllers =
        List.generate(5, (_) => TextEditingController());

    final List<FocusNode> focusNodes =
        List.generate(5, (_) => FocusNode());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {

            bool isPinComplete = pinControllers
                .every((controller) => controller.text.isNotEmpty);

            return Container(
              height: 520,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [

                  /// HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE2136E),
                      borderRadius:
                          BorderRadius.vertical(
                              top: Radius.circular(25)),
                    ),
                    child: const Center(
                      child: Text(
                        "bKash",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// STEP 1
                  if (step == 1) ...[
                    const Text("Enter your bKash account",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          setModalState(() {
                            phone = value;
                          });
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: "01XXXXXXXXX",
                          filled: true,
                          fillColor:
                              const Color(0xFFF2F6F0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              phone.length == 11
                                  ? const Color(0xFFE2136E)
                                  : Colors.grey,
                          minimumSize:
                              const Size(double.infinity, 50),
                        ),
                        onPressed: phone.length == 11
                            ? () {
                                setModalState(() {
                                  step = 2;
                                });
                              }
                            : null,
                        child: const Text("Proceed",
                            style:
                                TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],

                  /// STEP 2
                  if (step == 2) ...[
                    const Text("Enter your bKash PIN",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Text("৳${total.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children:
                          List.generate(5, (index) {
                        return Container(
                          width: 50,
                          height: 60,
                          margin:
                              const EdgeInsets.symmetric(
                                  horizontal: 6),
                          child: TextField(
                            controller:
                                pinControllers[index],
                            focusNode:
                                focusNodes[index],
                            keyboardType:
                                TextInputType.number,
                            textAlign:
                                TextAlign.center,
                            maxLength: 1,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter
                                  .digitsOnly
                            ],
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (index < 4) {
                                  focusNodes[index + 1]
                                      .requestFocus();
                                }
                              }
                              setModalState(() {});
                            },
                            decoration:
                                InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor:
                                  const Color(
                                      0xFFF2F6F0),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(12),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const Spacer(),

                    Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              isPinComplete
                                  ? const Color(
                                      0xFFE2136E)
                                  : Colors.grey,
                          minimumSize:
                              const Size(
                                  double.infinity, 50),
                        ),
                        onPressed: isPinComplete
                            ? () {
                                setModalState(() {
                                  step = 3;
                                });
                              }
                            : null,
                        child: const Text(
                          "Confirm Payment",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],

                  /// STEP 3 (IMPORTANT PART)
                  if (step == 3) ...[
                    const SizedBox(height: 60),
                    const Icon(Icons.check_circle,
                        size: 90,
                        color: Colors.green),
                    const SizedBox(height: 20),
                    const Text(
                      "Payment Successful!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold),
                    ),
                    const Spacer(),
                    Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                                  0xFF1B5E20),
                          minimumSize:
                              const Size(
                                  double.infinity, 50),
                        ),
                        onPressed: () {

                          /// ✅ SAVE ORDER FOR EACH CART ITEM
                          for (var product in CartService().cartItems) {
                            OrderService().addOrder(
                              OrderModel(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                name: product.name,
                                price: product.price,
                                imageUrl: product.imageUrl,
                                status: "Processing",
                                date: DateTime.now(),
                              ),
                            );
                          }

                          /// ✅ CLEAR CART
                          CartService().clearCart();

                          /// CLOSE MODAL
                          Navigator.pop(context);

                          /// GO HOME
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const HomePage()),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}