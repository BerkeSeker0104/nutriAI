import 'package:flutter/material.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final entries = [
      {'date': '2025-05-16', 'meal': 'Tatlı + kahve', 'mood': '😔'},
      {'date': '2025-05-15', 'meal': 'Tavuk salata', 'mood': '😊'},
    ];

    final suggestions = [
      'Dün geç yemek yediğin için bugün erken acıktın.',
      'Son 3 gündür hiç yeşil sebze tüketmedin.',
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '📅 Günlük Girişler',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...entries.map(
            (entry) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: theme.colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Text(
                  entry['mood']!,
                  style: const TextStyle(fontSize: 26),
                ),
                title: Text(entry['meal']!),
                subtitle: Text(entry['date']!),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const Text(
            '💡 AI Önerileri',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...suggestions.map(
            (s) => Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              color: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.lightbulb, color: Colors.green),
                title: Text(s),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
