import 'package:flutter/material.dart';
import 'payment_page.dart';

class CheckoutInfoPage extends StatefulWidget {
  const CheckoutInfoPage({super.key});

  @override
  State<CheckoutInfoPage> createState() => _CheckoutInfoPageState();
}

class _CheckoutInfoPageState extends State<CheckoutInfoPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();
  final countryController = TextEditingController();

  bool get isFormValid {
    final emailRegex =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex =
        RegExp(r'^01[0-9]{9}$'); // Bangladesh number

    return fullNameController.text.trim().length >= 3 &&
        emailRegex.hasMatch(emailController.text.trim()) &&
        phoneRegex.hasMatch(phoneController.text.trim()) &&
        streetController.text.trim().isNotEmpty &&
        cityController.text.trim().isNotEmpty &&
        stateController.text.trim().isNotEmpty &&
        zipController.text.trim().length >= 4 &&
        countryController.text.trim().isNotEmpty;
  }

  Widget buildTextField(
      String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.green.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("Checkout Information"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildTextField("Full Name", fullNameController),
            buildTextField("Email", emailController,
                type: TextInputType.emailAddress),
            buildTextField("Phone (01XXXXXXXXX)",
                phoneController,
                type: TextInputType.phone),
            buildTextField("Street Address", streetController),
            buildTextField("City", cityController),
            buildTextField("State", stateController),
            buildTextField("Zip Code", zipController,
                type: TextInputType.number),
            buildTextField("Country", countryController),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isFormValid
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentPage(
                              buyerName:
                                  fullNameController.text.trim(),
                              buyerEmail:
                                  emailController.text.trim(),
                              buyerPhone:
                                  phoneController.text.trim(),
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  "Continue to Payment",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}