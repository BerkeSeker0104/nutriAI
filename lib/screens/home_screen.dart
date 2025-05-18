import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _mealController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedMood;
  String _menstrualStatus = 'Yok';
  File? _imageFile;

  final List<String> moods = ['😊', '😔', '😡', '😴', '😐'];
  final List<String> menstrualOptions = ['Yok', 'Regl öncesi', 'Regl dönemi'];

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _submitEntry() {
    if (_mealController.text.isEmpty || _selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen yemek ve ruh halinizi girin')),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'meal': _mealController.text,
        'mood': _selectedMood,
        'note': _noteController.text,
        'time': DateTime.now().toString(),
        'menstrual_phase': _menstrualStatus,
      },
    );
  }

  void _selectMenstrualStatus() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children:
              menstrualOptions.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() => _menstrualStatus = option);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _mealController,
            decoration: InputDecoration(
              labelText: '🍽️ Ne Yedin?',
              hintText: 'Örneğin: Makarna, yoğurt...',
              fillColor: theme.colorScheme.surface,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          if (_imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_imageFile!, height: 150),
            ),
          TextButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.photo, color: theme.primaryColor),
            label: Text(
              'Yemek Fotoğrafı Ekle',
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🙂 Ruh Halin?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children:
                moods
                    .map(
                      (mood) => ChoiceChip(
                        label: Text(mood, style: const TextStyle(fontSize: 22)),
                        selected: _selectedMood == mood,
                        selectedColor: theme.primaryColor,
                        onSelected: (_) => setState(() => _selectedMood = mood),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '🩸 Regl Durumu',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _selectMenstrualStatus,
            icon: const Icon(Icons.keyboard_arrow_down),
            label: Text(_menstrualStatus),
            style: ElevatedButton.styleFrom(
              foregroundColor: theme.primaryColor,
              backgroundColor: theme.colorScheme.onPrimary,
              side: BorderSide(color: theme.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: '📝 Not (İsteğe Bağlı)',
              hintText: 'Bugünkü ruh halin, motivasyonun...',
              fillColor: theme.colorScheme.surface,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _submitEntry,
            icon: const Icon(Icons.analytics),
            label: const Text('Analizi Başlat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 6,
            ),
          ),
        ],
      ),
    );
  }
}
