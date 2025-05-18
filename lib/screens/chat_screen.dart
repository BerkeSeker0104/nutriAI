import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _flutterTts = FlutterTts();

  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();

    _flutterTts.setLanguage("tr-TR");
    _flutterTts.setSpeechRate(0.6);
    _flutterTts.setPitch(1.1);
    _flutterTts.setVolume(1.0);

    _flutterTts.setVoice({'name': 'tr-tr-x-fec-local', 'locale': 'tr-TR'});

    _flutterTts.getVoices.then((voices) {
      for (var voice in voices) {
        print("Ses: $voice");
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null && _messages.isEmpty) {
        final aiResponse = await GeminiService.getInsight(args);
        _addAIMessage(aiResponse);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final userMessage = {
      'sender': 'Sen',
      'text': input,
      'isUser': true,
      'time': DateTime.now(),
    };

    setState(() {
      _messages.add(userMessage);
      _controller.clear();
      _isTyping = true;
    });

    try {
      final lastAI = _messages.lastWhere(
        (m) => m['sender'] == 'nutriAI',
        orElse: () => {},
      );

      final lastText = (lastAI['text'] ?? '').toString().toLowerCase();
      final userReply = input.toLowerCase();

      String response;

      if (lastText.contains("daha detaylı değerlendirmemi ister misin") &&
          userReply.contains("evet")) {
        response = await GeminiService.getEvaluation(_messages);
      } else if (lastText.contains("iki sağlıklı öneri sunmamı ister misin") &&
          userReply.contains("evet")) {
        response = await GeminiService.getRecommendations(_messages);
      } else {
        final List<Map<String, String>> history =
            _messages
                .map(
                  (m) => {
                    'role': m['isUser'] ? 'user' : 'model',
                    'text': m['text'].toString(),
                  },
                )
                .toList();
        response = await GeminiService.getChatReply(history);
      }

      _addAIMessage(response);
    } catch (e) {
      _addAIMessage('❌ Yanıt alınamadı: $e');
    }
  }

  void _addAIMessage(String text) {
    setState(() {
      _messages.add({
        'sender': 'nutriAI',
        'text': text,
        'isUser': false,
        'time': DateTime.now(),
      });
      _isTyping = false;
      _isSpeaking = true;
    });

    _flutterTts.speak(text);

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final theme = Theme.of(context);
    final color =
        isUser ? theme.colorScheme.surfaceVariant : Colors.green.shade100;

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser)
              AvatarGlow(
                glowColor: Colors.greenAccent,
                endRadius: 30.0,
                animate: _isSpeaking,
                duration: const Duration(milliseconds: 1500),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/nutri_bot.png'),
                  radius: 18,
                ),
              ),
            if (!isUser) const SizedBox(width: 8),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(14),
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 0),
                    bottomRight: Radius.circular(isUser ? 0 : 16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message['sender'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message['text'],
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
          child: Text(
            "${message['time'].hour.toString().padLeft(2, '0')}:${message['time'].minute.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 12, color: Colors.black38),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        title: const Text('nutriAI', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildBubble(_messages[index]),
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Mesajınızı yazın...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.green.shade700,
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
