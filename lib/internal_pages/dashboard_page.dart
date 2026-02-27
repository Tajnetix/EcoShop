import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Purchase {
  final String name;
  final int points;
  final double co2;

  Purchase({
    required this.name,
    required this.points,
    required this.co2,
  });
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final supabase = Supabase.instance.client;

  List<Purchase> purchases = [];
  int totalPoints = 0;
  double totalCO2 = 0;
  double monthlyCO2 = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final profile = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      final firstDay =
          DateTime(DateTime.now().year, DateTime.now().month, 1);

      final monthlyOrders = await supabase
          .from('orders')
          .select('co2_saved')
          .eq('user_id', user.id)
          .gte('created_at', firstDay.toIso8601String());

      double monthTotal = 0;
      for (var o in monthlyOrders) {
        monthTotal += (o['co2_saved'] as num).toDouble();
      }

      final orders = await supabase
          .from('orders')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(5);

      List<Purchase> loaded = [];
      for (var o in orders) {
        loaded.add(Purchase(
          name: o['product_name'],
          points: o['eco_points'],
          co2: (o['co2_saved'] as num).toDouble(),
        ));
      }

      setState(() {
        totalPoints = profile['total_eco_points'] ?? 0;
        totalCO2 =
            (profile['total_co2_saved'] ?? 0).toDouble();
        monthlyCO2 = monthTotal;
        purchases = loaded;
        isLoading = false;
      });
    } catch (e) {
      print("Dashboard error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double goal = 5;
    double percent = (monthlyCO2 / goal).clamp(0, 1);

    return Scaffold(
      backgroundColor: const Color(0xFFDDE8D3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Eco Dashboard",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Row(
              children: [
                _card(Icons.workspace_premium,
                    "Eco Points", "$totalPoints"),
                const SizedBox(width: 12),
                _card(Icons.eco,
                    "Total CO₂",
                    "${totalCO2.toStringAsFixed(2)} kg"),
              ],
            ),

            const SizedBox(height: 20),

            CircularProgressIndicator(
              value: percent,
              strokeWidth: 10,
            ),

            const SizedBox(height: 8),

            Text("${monthlyCO2.toStringAsFixed(2)} / 5 kg this month"),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Recent Purchases"),
            ),

            const SizedBox(height: 10),

            ...purchases.map((p) => ListTile(
                  title: Text(p.name),
                  subtitle: Text(
                      "+${p.points} points • ${p.co2} kg CO₂"),
                ))
          ],
        ),
      ),
    );
  }

  Widget _card(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(height: 6),
            Text(title),
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}