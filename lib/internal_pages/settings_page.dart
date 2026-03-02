import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1B5E20),
      ),
      body: ListView(
        children: [
          _settingsItem(context, 'Notifications', Icons.notifications),
          _settingsItem(context, 'Privacy', Icons.lock),
          _settingsItem(context, 'Language', Icons.language),
          _settingsItem(context, 'Theme', Icons.palette),
        ],
      ),
    );
  }

  Widget _settingsItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title clicked')));
      },
    );
  }
}