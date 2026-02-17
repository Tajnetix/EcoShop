import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFC8E6C9),
              child: Icon(
                Icons.person_add,
                size: 36,
                color: Color(0xFF1B5E20),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'EcoShop',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Create Your Account',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            _buildField(
              hint: 'Name',
              icon: Icons.person_outline,
              obscure: false,
            ),

            const SizedBox(height: 16),

            _buildField(
              hint: 'Email (example@gmail.com)',
              icon: Icons.email_outlined,
              obscure: false,
            ),

            const SizedBox(height: 16),

            _buildField(
              hint: 'Password',
              icon: Icons.lock_outline,
              obscure: hidePassword,
              suffix: IconButton(
                icon: Icon(
                  hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF1B5E20),
                ),
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                      Navigator.pushNamed(context, '/pin');
                    },

                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Already have an account? Sign in',
                style: TextStyle(
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'or continue with',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: _socialButton('Google', Icons.g_mobiledata)),
                const SizedBox(width: 12),
                Expanded(child: _socialButton('Apple', Icons.apple)),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String hint,
    required IconData icon,
    required bool obscure,
    Widget? suffix,
  }) {
    return TextField(
      obscureText: obscure,
      keyboardType: hint.contains('Email')
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1B5E20)),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFDCECCB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _socialButton(String text, IconData icon) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFDCECCB),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF1B5E20)),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}