import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      "title": "Yemek & Ruh Halin Takip Ediliyor",
      "desc":
          "Yediklerini ruh halinle birlikte girerek duygusal yeme alışkanlıklarını fark et.",
      "image": "assets/onboarding1.png",
    },
    {
      "title": "nutriAI seninle!",
      "desc":
          "Yapay zeka seni analiz eder, öneriler verir, alışkanlık döngülerini keşfeder.",
      "image": "assets/onboarding2.png",
    },
    {
      "title": "Gelişimini Takip Et",
      "desc":
          "Haftalık içgörüler, sağlıklı öğünler ve davranışsal farkındalık seni bekliyor!",
      "image": "assets/onboarding3.png",
    },
  ];

  void _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: PageView.builder(
        controller: _controller,
        itemCount: _slides.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(_slides[index]['image']!, height: 260),
                const SizedBox(height: 30),
                Text(
                  _slides[index]['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _slides[index]['desc']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed:
                      index == _slides.length - 1
                          ? _finish
                          : () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    index == _slides.length - 1 ? 'Başla' : 'İleri',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
