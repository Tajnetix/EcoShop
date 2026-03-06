import 'package:flutter/material.dart';
import '../supabase_client.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool hidePassword = true;
  bool _loading = false;

  final TextEditingController _nameController = TextEditingController();
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
              child: Icon(Icons.person_add, size: 36, color: Color(0xFF1B5E20)),
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
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            _buildField(
              controller: _nameController,
              hint: 'Name',
              icon: Icons.person_outline,
              obscure: false,
            ),

            const SizedBox(height: 16),

            _buildField(
              controller: _emailController,
              hint: 'Email (example@gmail.com)',
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
                onPressed: _loading ? null : _signUp,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= AUTH LOGIC =================

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('All fields are required');
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (res.user == null) {
        _showError('Signup failed');
      } else {
        final userId = res.user!.id;

        // IMPORTANT: create profile row
        await supabase.from('profiles').upsert({'id': userId, 'email': email});

        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/login',
            arguments: {'mode': 'signup', 'userId': userId},
          );
        }
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI HELPERS =================

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
}