import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart'; 

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
  double totalCO2 = 0.0;
  double monthlyCO2 = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final response = await supabase
          .from('orders')
          .select()
          .order('created_at', ascending: false);

      int pointsTemp = 0;
      double co2Temp = 0.0;
      double monthTemp = 0.0;

      final firstDay =
          DateTime(DateTime.now().year, DateTime.now().month, 1);

      List<Purchase> loaded = [];

      for (var o in response) {
        final int points =
            (o['eco_points'] as num?)?.toInt() ?? 0;

        final double co2 =
            (o['co2_saved'] as num?)?.toDouble() ?? 0.0;

        final DateTime createdAt =
            DateTime.tryParse(o['created_at'] ?? '') ??
                DateTime.now();

        pointsTemp += points;
        co2Temp += co2;

        if (createdAt.isAfter(firstDay)) {
          monthTemp += co2;
        }

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
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double goal = 5.0;
    double percent =
        goal == 0 ? 0 : (monthlyCO2 / goal).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFFE8F3E5),

      /// ✅ BACK NAVIGATOR ADDED
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => const HomePage()),
            );
          },
        ),
        title: const Text(
          "Eco Dashboard",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB7D7A8),
                      Color(0xFF8FCB81),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.eco,
                          color: Colors.white, size: 30),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Impact",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Track your eco-friendly journey",
                          style:
                              TextStyle(color: Colors.white70),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// STAT CARDS
              Row(
                children: [
                  _statCard("Eco Points", "$totalPoints"),
                  const SizedBox(width: 12),
                  _statCard(
                      "Total CO₂",
                      "${totalCO2.toStringAsFixed(2)} kg"),
                ],
              ),

              const SizedBox(height: 24),

              /// CARBON IMPACT
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Carbon Impact",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: percent,
                            strokeWidth: 12,
                            backgroundColor:
                                Colors.green.shade100,
                            color: Colors.green,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "${(percent * 100).toInt()}%",
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: Colors.green),
                            ),
                            const Text("CO₂ Reduction")
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Total Carbon Saved\nEquivalent to ${(totalCO2 * 4).toStringAsFixed(0)} km not driven",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Recent Sustainable Purchases",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              purchases.isEmpty
                  ? const Center(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 20),
                        child: Text(
                          "No purchases yet",
                          style:
                              TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: purchases
                          .map((p) => Container(
                                margin:
                                    const EdgeInsets.only(
                                        bottom: 12),
                                padding:
                                    const EdgeInsets.all(
                                        16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius
                                          .circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      p.name,
                                      style:
                                          const TextStyle(
                                              fontSize:
                                                  16,
                                              fontWeight:
                                                  FontWeight
                                                      .w600),
                                    ),
                                    const SizedBox(
                                        height: 6),
                                    Row(
                                      children: [
                                        Text(
                                            "+${p.points} points"),
                                        const SizedBox(
                                            width: 16),
                                        Text(
                                            "${p.co2.toStringAsFixed(2)} kg CO₂"),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                          .toList(),
                    ),

              const SizedBox(height: 24),

              /// MONTHLY GOAL
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFDFF0D8),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Monthly Goal",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        "Save 5kg of CO₂ this month"),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percent,
                      backgroundColor:
                          Colors.green.shade100,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "${monthlyCO2.toStringAsFixed(2)} / 5 kg"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(title),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}