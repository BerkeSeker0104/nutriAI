import 'package:flutter/material.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final List<Map<String, dynamic>> dailyStats = const [
    {'day': 'Pzt', 'mood': '😊', 'score': 7},
    {'day': 'Sal', 'mood': '😔', 'score': 4},
    {'day': 'Çar', 'mood': '😐', 'score': 5},
    {'day': 'Per', 'mood': '😊', 'score': 8},
    {'day': 'Cum', 'mood': '😴', 'score': 3},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final cardColor = isDark ? Colors.green.shade900 : Colors.green.shade50;
    final progressBg = isDark ? Colors.green.shade800 : Colors.green.shade100;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Kullanıcı Bilgisi
            Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/woman-7165664_1280.jpg'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Ad: Damla', style: TextStyle(fontSize: 18)),
                    Text('Soyad: Kaya', style: TextStyle(fontSize: 18)),
                    Text('Yaş: 20', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              '📅 Gün Gün Durumun',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...dailyStats.map((entry) {
              return Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Text(
                    entry['mood'],
                    style: const TextStyle(fontSize: 28),
                  ),
                  title: Text('${entry['day']} günü'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: entry['score'] / 10.0,
                        color: primaryColor,
                        backgroundColor: progressBg,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 4),
                      Text('Kalori skoru: ${entry['score']}/10'),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),
            const Text(
              '✨ nutriAI Tavsiyesi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Üzgün olduğun günlerde karbonhidrat tüketimin belirgin şekilde artıyor.\n'
                  'Duygusal açlık yerine su içmek, yürüyüş yapmak gibi alışkanlıklar edinmeyi dene.',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              '🥗 Bu Hafta Kurtarılan Sağlıklı Öğünler',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              color: Colors.lightGreen.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    '5 öğün 🎉',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/analytics');
              },
              child: Card(
                color: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bar_chart, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'İstatistikleri Gör',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            // 💳 Abonelik Bilgileri Butonu
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: const Icon(Icons.credit_card, color: Colors.green),
              title: const Text('Abonelik Bilgileri'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/subscription');
              },
            ),
          ],
        ),
      ),
    );
  }
}
