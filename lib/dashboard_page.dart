import 'package:flutter/material.dart';

class Purchase {
  final String name;
  final int points;
  final double co2;
  final String daysAgo;

  const Purchase({
    required this.name,
    required this.points,
    required this.co2,
    required this.daysAgo,
  });
}


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // ===== MOCK DATA =====
  final List<Purchase> purchases = const [
    Purchase(
      name: "Bamboo Toothbrush Set",
      points: 50,
      co2: 0.15,
      daysAgo: "2 days ago",
    ),
    Purchase(
      name: "Reusable Water Bottle",
      points: 100,
      co2: 0.82,
      daysAgo: "5 days ago",
    ),
  ];

  double get totalCO2 =>
      purchases.fold(0, (sum, p) => sum + p.co2);

  int get totalPoints =>
      purchases.fold(0, (sum, p) => sum + p.points);

  int get totalPurchases => purchases.length;

  @override
  Widget build(BuildContext context) {

    double goal = 5;
    double percent = (totalCO2 / goal).clamp(0, 1);

    return Scaffold(
      backgroundColor: const Color(0xFFDDE8D3),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Eco Dashboard",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: const Icon(Icons.close, color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== YOUR IMPACT =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade200.withOpacity(.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.eco, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Your Impact",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text("Track your eco-friendly journey"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== POINTS & PURCHASES =====
            Row(
              children: [
                _smallCard(Icons.workspace_premium,
                    "Eco Points", "$totalPoints"),
                const SizedBox(width: 12),
                _smallCard(Icons.shopping_bag,
                    "Purchases", "$totalPurchases"),
              ],
            ),

            const SizedBox(height: 18),

            // ===== CARBON IMPACT =====
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Carbon Impact",
                        style: TextStyle(fontSize: 18)),
                  ),

                  const SizedBox(height: 18),

                  // CIRCLE CENTERED
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 160,
                        width: 160,
                        child: CircularProgressIndicator(
                          value: percent,
                          strokeWidth: 12,
                          backgroundColor: Colors.green.shade100,
                          color: Colors.green,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "${(percent*100).toInt()}%",
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text("CO₂ Reduction"),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text("Total Carbon Saved"),
                  Text("${totalCO2.toStringAsFixed(2)} kg",
                      style: const TextStyle(fontSize: 20)),

                  Text(
                    "Equivalent to ${(totalCO2*4).toStringAsFixed(0)} km not driven",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text("Achievements",
                style: TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            _achievement(Icons.eco,
                "Eco Beginner",
                "Made your first sustainable purchase",
                unlocked: totalPurchases>=1),

            _achievement(Icons.workspace_premium,
                "Planet Protector",
                "Saved 1kg of CO₂",
                unlocked: totalCO2>=1),

            _achievement(Icons.emoji_events,
                "Green Champion",
                "Earned 500 eco points",
                unlocked: totalPoints>=500),

            const SizedBox(height: 20),

            const Text("Recent Sustainable Purchases",
                style: TextStyle(fontSize: 18)),

            const SizedBox(height: 12),

            ...purchases.map((p) => _purchaseBox(p)),

            const SizedBox(height: 20),

            // ===== MONTHLY GOAL =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade200.withOpacity(.4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.trending_up),
                      SizedBox(width: 8),
                      Text("Monthly Goal",
                          style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Save 5kg of CO₂ this month"),
                  const SizedBox(height: 10),

                  LinearProgressIndicator(
                    value: percent,
                    backgroundColor: Colors.white,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 6),
                  Text("${totalCO2.toStringAsFixed(2)} / 5 kg"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== SMALL TOP CARDS =====
  Widget _smallCard(IconData icon, String title, String value) {
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

  // ===== ACHIEVEMENTS =====
  Widget _achievement(
      IconData icon, String title, String sub,
      {bool unlocked=true}) {

    return Opacity(
      opacity: unlocked?1:.4,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Icon(icon, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),
                Text(sub),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ===== PURCHASE BOX =====
  Widget _purchaseBox(Purchase p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(p.name,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Text(p.daysAgo,
              style: const TextStyle(color: Colors.grey)),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(Icons.workspace_premium,
                  size: 18, color: Colors.green),
              const SizedBox(width: 4),
              Text("+${p.points} points"),

              const SizedBox(width: 16),

              const Icon(Icons.eco,
                  size: 18, color: Colors.green),
              const SizedBox(width: 4),
              Text("${p.co2} kg CO₂"),
            ],
          )
        ],
      ),
    );
  }
}
