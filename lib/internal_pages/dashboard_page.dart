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
    double percent = goal == 0 ? 0 : (monthlyCO2 / goal).clamp(0.0, 1.0);

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
        title: const Text(
          "Eco Dashboard",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= HEADER =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8BC34A), Color(0xFF66BB6A)],
                ),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.eco,
                        color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Impact",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Track your eco-friendly journey",
                        style: TextStyle(
                            color: Colors.white70),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ================= POINTS & CO2 =================
            Row(
              children: [
                Expanded(
                  child: _statCard(
                      "Eco Points",
                      totalPoints.toString()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                      "Total CO₂",
                      "${totalCO2.toStringAsFixed(2)} kg"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ================= CARBON IMPACT (BIG CLEAN VERSION) =================
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(22),
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 28),
    child: Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Carbon Impact",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),

        /// BIG Smooth Circle
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: percent),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return SizedBox(
              height: 190,
              width: 190,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Soft background circle
                  Container(
                    height: 190,
                    width: 190,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade50,
                    ),
                  ),

                  // Progress ring
                  SizedBox(
                    height: 170,
                    width: 170,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 12,
                      backgroundColor: Colors.green.shade100,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF66BB6A),
                      ),
                    ),
                  ),

                  // Center Text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${(value * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "CO₂ Reduction",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 22),

        Text(
          "Total Carbon Saved",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "${totalCO2.toStringAsFixed(2)} kg",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Equivalent to ${(totalCO2 * 4).toStringAsFixed(0)} km not driven",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ),
),

            /// ================= RECENT PURCHASES =================
            const Text(
              "Recent Sustainable Purchases",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...purchases.map((p) => Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        "+${p.points} points    ${p.co2.toStringAsFixed(2)} kg CO₂",
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13),
                      )
                    ],
                  ),
                )),

            const SizedBox(height: 20),

            /// ================= MONTHLY GOAL =================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text("Monthly Goal",
                      style: TextStyle(
                          fontWeight:
                              FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("Save 5kg of CO₂ this month"),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor:
                        Colors.green.shade200,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${monthlyCO2.toStringAsFixed(2)} / 5 kg",
                    style: TextStyle(
                        color: Colors.grey[700]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: Colors.grey[700])),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}