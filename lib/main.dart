import 'package:eco_friendly_store/logout_page.dart';
import 'package:eco_friendly_store/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/first_page.dart';
import 'pages/signup_page.dart';
import 'pages/pin_page.dart';
import 'pages/login_page.dart';
import 'internal_pages/home_page.dart';
import 'internal_pages/category_page.dart';
import 'internal_pages/favorite_page.dart';
import 'internal_pages/profile_page.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  //supabase setup
  await Supabase.initialize(
    anonKey: "sb_publishable_6KijuU1K3gJeu_Qisd_-0g_ZtOAmmwE",
    url: "https://zuwciizknpdywuexruen.supabase.co",
  );

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstPage(),
        '/signup': (context) => const SignupPage(),
        '/pin': (context) => const PinPage(),
        '/reset-password': (_) => const ResetPasswordPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/category': (context) => const CategoryPage(),
        '/favorite': (context) => const FavoritePage(),
        '/profile': (context) => const ProfilePage(),
        '/logout': (context) => const LogoutPage(),
      },
    );
  }
}