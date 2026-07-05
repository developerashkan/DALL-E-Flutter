import 'dart:async';
import 'package:flutter/material.dart';
import 'dalle_generate_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return; 

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DallEGenerateScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo-no-background.png",
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
