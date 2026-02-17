import 'package:flutter/material.dart';

import 'first_page.dart';
import 'signup_page.dart';
import 'pin_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';
import 'logout_page.dart';
import 'dashboard_page.dart';

void main() {
  runApp(const EcoShopApp());
}

class EcoShopApp extends StatelessWidget {
  const EcoShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoShop',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const FirstPage(),
        '/signup': (context) => const SignupPage(),
        '/pin': (context) => const PinPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),

        '/category': (context) => const CategoryPage(),
        '/favorite': (context) => const FavoritePage(),
        '/profile': (context) => const ProfilePage(),
        '/logout': (context) => const LogoutPage(),

        // ✅ Dashboard route
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
