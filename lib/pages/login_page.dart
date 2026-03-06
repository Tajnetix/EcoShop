import 'package:flutter/material.dart';
import '../supabase_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  bool loading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFC8E6C9),
              child: Icon(
                Icons.shopping_bag,
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
              'Login to Your Account',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            _buildField(
              controller: _emailController,
              hint: 'Email',
              icon: Icons.email_outlined,
              obscure: false,
            ),

            const SizedBox(height: 16),

            _buildField(
              controller: _passwordController,
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
                onPressed: () => setState(() => hidePassword = !hidePassword),
              ),
            ),

            const SizedBox(height: 20),

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
                onPressed: loading ? null : _login,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),

            const SizedBox(height: 15),

            /// ✅ Forgot password (only once)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/reset-password');
              },
              child: const Text(
                'Forgot your password?',
                style: TextStyle(
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const SizedBox(height: 25),

            /// ✅ Signup option restored
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: const Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= EMAIL LOGIN =================

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Email & password required");
      return;
    }

    setState(() => loading = true);

    try {
      await supabase.auth.signInWithPassword(email: email, password: password);

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _showError("Invalid credentials");
    } finally {
      setState(() => loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool obscure,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: hint == 'Email'
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
}