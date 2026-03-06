import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  Future<void> _updatePassword() async {
    final password = _passwordController.text.trim();

    if (password.length < 6) {
      _show("Minimum 6 characters required");
      return;
    }

    setState(() => loading = true);

    try {
      await supabase.auth.updateUser(UserAttributes(password: password));

      _show("Password updated successfully");

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _show("Update failed");
    } finally {
      setState(() => loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Your password")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Enter new password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _updatePassword,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}