import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _apiKey = 'AIzaSyAj6eEBj9gQrKPxYjNIBLJ9UbKIphPKAjs';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro';

  // 1️⃣ İlk AI içgörüsü (kullanıcı verisi ile)
  static Future<String> getInsight(Map<String, dynamic> input) async {
    final prompt = '''
Kullanıcının yeme davranışıyla ilgili **davranışsal bir içgörü** üret. (1-2 cümle)

Veriler:
🍽️ Yemek: ${input['meal']}
🙂 Ruh hali: ${input['mood']}
🩸 Regl durumu: ${input['menstrual_phase']}
📝 Açıklama: ${input['note']}
⏰ Zaman: ${input['time']}

Kısa, samimi ve koç gibi konuş. İçgörüyü doğrudan söyle, başlık koyma. 
Cümle sonunda: "Bu durumu daha detaylı değerlendirmemi ister misin?" diye sor.
''';

    return await _generate(prompt);
  }

  // 2️⃣ Kullanıcı "evet" dedikten sonra gelen durum analizi
  static Future<String> getEvaluation(
    List<Map<String, dynamic>> messages,
  ) async {
    final latestMeal = messages.firstWhere(
      (m) => m['text'].toString().contains('Yemek:'),
      orElse: () => {'text': ''},
    );

    final prompt = '''
Aşağıdaki kullanıcı sohbet geçmişine göre **genel bir durum değerlendirmesi** yap.

Kullanıcı mesajları:
${messages.map((m) => "${m['sender']}: ${m['text']}").join("\n")}

Yemek verisi:
${latestMeal['text']}

Koçvari ve destekleyici bir tonla 3-4 cümle yaz. Son cümlede: 
"İki sağlıklı öneri sunmamı ister misin?" diye sor.
''';

    return await _generate(prompt);
  }

  // 3️⃣ Öneriler: Kullanıcı evet derse iki sağlıklı öğün önerisi
  static Future<String> getRecommendations(
    List<Map<String, dynamic>> messages,
  ) async {
    final prompt = '''
Aşağıdaki konuşma geçmişine göre kullanıcıya iki uygulanabilir sağlıklı beslenme önerisi sun.

Kullanıcı mesaj geçmişi:
${messages.map((m) => "${m['sender']}: ${m['text']}").join("\n")}

Cevap formatı şu şekilde olmalı:

🍽️ Öneri 1:
- Gıda: [besin adı]
- Sebep: [neden bu besin uygun]

🥗 Öneri 2:
- Gıda: [besin adı]
- Sebep: [neden bu besin uygun]

Yanıt koç gibi motive edici ve sade olmalı. 
Son cümle olarak "Bunlar sana uygun mu, başka öneri ister misin?" diye sor.
''';

    return await _generate(prompt);
  }

  // 4️⃣ Gerçek zamanlı sohbet için açık uçlu mesaj yanıtı
  static Future<String> getChatReply(List<Map<String, String>> messages) async {
    final contentList =
        messages.map((msg) {
          return {
            "role": msg['role'], // "user" veya "model"
            "parts": [
              {"text": msg['text']},
            ],
          };
        }).toList();

    final response = await http.post(
      Uri.parse('$_baseUrl:generateContent?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"contents": contentList}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception(
        'Gemini chat hatası: ${response.statusCode}\nMesaj: ${response.body}',
      );
    }
  }

  // ✅ Ortak içerik üretici (tek mesajlı prompt'lar için)
  static Future<String> _generate(String prompt) async {
    final response = await http.post(
      Uri.parse('$_baseUrl:generateContent?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception(
        'Gemini API hatası: ${response.statusCode}\nMesaj: ${response.body}',
      );
    }
  }
}
