import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

class Purchase {
  final String name;
  final int points;
  final double co2;

  Purchase({required this.name, required this.points, required this.co2});
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
  double totalCO2 = 0.0;
  double monthlyCO2 = 0.0;
  bool isLoading = true;
  bool isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        setState(() {
          isLoggedIn = false;
          isLoading = false;
        });
        return;
      }

      final response = await supabase
          .from('orders')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      int pointsTemp = 0;
      double co2Temp = 0.0;
      double monthTemp = 0.0;
      final firstDay =
          DateTime(DateTime.now().year, DateTime.now().month, 1);

      List<Purchase> loaded = [];

      for (var o in response) {
        final int points = (o['eco_points'] as num?)?.toInt() ?? 0;
        final double co2 = (o['co2_saved'] as num?)?.toDouble() ?? 0.0;
        final DateTime createdAt =
            DateTime.tryParse(o['created_at'] ?? '') ?? DateTime.now();

        pointsTemp += points;
        co2Temp += co2;
        if (createdAt.isAfter(firstDay)) monthTemp += co2;

        loaded.add(Purchase(
          name: o['product_name'] ?? "Product",
          points: points,
          co2: co2,
        ));
      }

      setState(() {
        totalPoints = pointsTemp;
        totalCO2 = co2Temp;
        monthlyCO2 = monthTemp;
        purchases = loaded.take(5).toList();
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

    if (!isLoggedIn) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Please login to view your dashboard",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    double goal = 5.0;
    double percent =
        goal == 0 ? 0 : (monthlyCO2 / goal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3E5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        title: const Text("Eco Dashboard",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === KEEP YOUR ORIGINAL STAT CARDS UI HERE ===
              // Example for total points
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Total Points: $totalPoints"),
                      Text("Total CO2 Saved: ${totalCO2.toStringAsFixed(2)} kg"),
                      Text("Monthly CO2: ${monthlyCO2.toStringAsFixed(2)} kg"),
                      LinearProgressIndicator(value: percent),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // === Purchases List ===
              const Text(
                "Recent Purchases",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...purchases.map((p) => ListTile(
                    title: Text(p.name),
                    subtitle:
                        Text("${p.points} points • ${p.co2} kg CO2 saved"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}