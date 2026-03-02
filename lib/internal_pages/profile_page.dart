import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_page.dart';
import 'edit_profile_page.dart';
import 'order_history_page.dart';
import 'settings_page.dart';
// import 'reviews_page.dart'; // uncomment if you create a ReviewsPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;

  String name = "Guest User";
  String email = "";
  int totalOrders = 0;
  int ecoPoints = 0;
  double co2Saved = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    setState(() => isLoading = true);

    final user = supabase.auth.currentUser;

    if (user != null) {
      // Logged-in user
      name = user.userMetadata?['full_name'] ?? "User";
      email = user.email ?? "";

      final ordersResponse = await supabase
          .from('orders')
          .select()
          .eq('user_id', user.id);

      totalOrders = ordersResponse.length;
      ecoPoints = 0;
      co2Saved = 0.0;

      for (var o in ordersResponse) {
        ecoPoints += (o['eco_points'] as num?)?.toInt() ?? 0;
        co2Saved += (o['co2_saved'] as num?)?.toDouble() ?? 0.0;
      }
    } else {
      // Guest user
      name = "Guest User";
      email = "";
      totalOrders = 0;
      ecoPoints = 0;
      co2Saved = 0.0;
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCECCB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFC8DAB5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xFFE5EFE0),
                          child: Icon(Icons.person,
                              size: 35, color: Color(0xFF1B5E20)),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 4),
                            Text(email.isEmpty ? "Guest User" : email),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatCard(title: 'Orders', value: totalOrders.toString()),
                      _StatCard(title: 'Eco Points', value: ecoPoints.toString()),
                      _StatCard(
                          title: 'CO₂ Saved',
                          value: "${co2Saved.toStringAsFixed(2)} kg"),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Menu Items
                  _menuItem(
                    icon: Icons.edit,
                    title: "Edit Profile",
                    subtitle: "Change your info",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditProfilePage()),
                      );
                    },
                  ),
                  _menuItem(
                    icon: Icons.history,
                    title: "Order History",
                    subtitle: "View your orders",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OrderHistoryPage()),
                      );
                    },
                  ),
                  _menuItem(
                    icon: Icons.settings,
                    title: "Settings",
                    subtitle: "App preferences",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SettingsPage()),
                      );
                    },
                  ),
                  _menuItem(
                    icon: Icons.reviews,
                    title: "Reviews",
                    subtitle: "View your product reviews",
                    onTap: () {
                      // TODO: implement Reviews page navigation
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewsPage()));
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _StatCard({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}