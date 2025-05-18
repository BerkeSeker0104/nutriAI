import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'profile_edit_screen.dart';
import 'kvkk_screen.dart';
import 'complaint_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('🌗 Koyu Tema'),
            value: isDark,
            onChanged: (value) => themeProvider.toggleTheme(value),
          ),
          const Divider(height: 32),

          // 👤 Profil düzenleme
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Profil Bilgilerini Düzenle'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
              );
            },
          ),

          // 📄 KVKK
          ListTile(
            leading: const Icon(Icons.policy),
            title: const Text('KVKK Aydınlatma Metni'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KvkkScreen()),
              );
            },
          ),

          // 🚨 Şikayet
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Şikayet Bildir'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ComplaintScreen()),
              );
            },
          ),

          const Divider(height: 32),
          const ListTile(title: Text('📦 Sürüm'), subtitle: Text('v1.0.0')),
        ],
      ),
    );
  }
}
