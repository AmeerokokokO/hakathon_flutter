import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../config/api_config.dart';
import '../data/models/chat_message_model.dart';
import '../services/ai_chat_service.dart';
import '../services/openrouter_service.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final AIChatService _geminiService = AIChatService();
  final OpenRouterService _grokService = OpenRouterService();
  bool _isTyping = false;
  String _currentModel = ApiConfig.modelTypeGemini; // Default to Gemini
  int? _lastReasoningTokens;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  String get currentModel => _currentModel;
  int? get lastReasoningTokens => _lastReasoningTokens;
  bool get isUsingGrok => _currentModel == ApiConfig.modelTypeGrok;

  ChatProvider() {
    _initializeChat();
  }

  void _initializeChat() {
    // Welcome message
    _messages.add(
      ChatMessage(
        id: const Uuid().v4(),
        content:
            'مرحباً بك في MedAssist AI! 👋\n\nأنا مساعدك الطبي الذكي. كيف يمكنني مساعدتك اليوم?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  void switchModel(String modelType) {
    if (modelType == ApiConfig.modelTypeGemini ||
        modelType == ApiConfig.modelTypeGrok) {
      _currentModel = modelType;
      _lastReasoningTokens = null; // Reset reasoning tokens when switching
      notifyListeners();
    }
  }

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    notifyListeners();

    // Show typing indicator
    _isTyping = true;
    _lastReasoningTokens = null;
    notifyListeners();

    try {
      String response;

      if (_currentModel == ApiConfig.modelTypeGrok) {
        // Use OpenRouter Grok with streaming
        String streamedContent = '';

        final result = await _grokService.sendMessage(
          content,
          stream: true,
          onChunk: (chunk) {
            streamedContent += chunk;
            // Update the last message with streamed content
            if (_messages.isNotEmpty && !_messages.last.isUser) {
              _messages.removeLast();
            }
            _messages.add(ChatMessage(
              id: const Uuid().v4(),
              content: streamedContent,
              isUser: false,
              timestamp: DateTime.now(),
            ));
            notifyListeners();
          },
          onReasoningTokens: (tokens) {
            _lastReasoningTokens = tokens;
            notifyListeners();
          },
        );

        if (result['success'] == true) {
          response = result['response'] ?? streamedContent;
          _lastReasoningTokens = result['reasoning_tokens'];
        } else {
          response = result['error'] ?? 'حدث خطأ في الاتصال';
        }

        // Remove typing indicator
        _isTyping = false;

        // Make sure final response is set
        if (_messages.isNotEmpty && !_messages.last.isUser) {
          _messages.removeLast();
        }
      } else {
        // Use Gemini
        response = await _geminiService.sendMessage(content);
        _isTyping = false;
      }

      // Add AI message (for Gemini or final Grok response)
      final aiMessage = ChatMessage(
        id: const Uuid().v4(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(aiMessage);
      notifyListeners();
    } catch (e) {
      _isTyping = false;
      final errorMessage = ChatMessage(
        id: const Uuid().v4(),
        content: 'عذراً، حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    _initializeChat();
    notifyListeners();
  }

  void deleteMessage(String messageId) {
    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();
  }
}
