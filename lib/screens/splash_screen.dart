import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _showSlogan = false;

  @override
  void initState() {
    super.initState();

    // Sloganı 500ms sonra göster
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showSlogan = true;
      });
    });

    // Onboarding'e geçiş
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFE8F5E9,
      ), // ✅ Onboarding ile aynı renk (Colors.green.shade50)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 160),
            const SizedBox(height: 20),
            AnimatedSlide(
              duration: const Duration(milliseconds: 800),
              offset: _showSlogan ? Offset.zero : const Offset(0, 0.3),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _showSlogan ? 1 : 0,
                child: const Text(
                  'Kişisel Beslenme Asistanınız',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
