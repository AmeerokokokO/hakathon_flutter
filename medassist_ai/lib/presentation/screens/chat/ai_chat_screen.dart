import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../config/api_config.dart';
import '../../../config/theme/app_colors.dart';
import '../../../providers/chat_provider.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            final modelName = chatProvider.isUsingGrok ? 'Grok' : 'Gemini';
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'MedAssist AI',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$modelName • مساعدك الطبي الذكي',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              return PopupMenuButton<String>(
                icon: Icon(
                  chatProvider.isUsingGrok
                      ? Icons.auto_awesome
                      : Icons.lightbulb_outline,
                ),
                tooltip: 'تبديل النموذج',
                onSelected: (value) {
                  chatProvider.switchModel(value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value == ApiConfig.modelTypeGrok
                            ? '🚀 تم التبديل إلى Grok (أسرع وأذكى)'
                            : '💡 تم التبديل إلى Gemini',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ApiConfig.modelTypeGemini,
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: chatProvider.currentModel ==
                                  ApiConfig.modelTypeGemini
                              ? AppColors.primaryBlue
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Gemini 1.5 Flash',
                          style: TextStyle(
                            fontWeight: chatProvider.currentModel ==
                                    ApiConfig.modelTypeGemini
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ApiConfig.modelTypeGrok,
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: chatProvider.currentModel ==
                                  ApiConfig.modelTypeGrok
                              ? AppColors.accentTeal
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Grok 4.1 Fast',
                          style: TextStyle(
                            fontWeight: chatProvider.currentModel ==
                                    ApiConfig.modelTypeGrok
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('مسح المحادثة'),
                  content: const Text('هل أنت متأكد من مسح جميع الرسائل؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ChatProvider>().clearChat();
                        Navigator.pop(context);
                      },
                      child: const Text('مسح'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length +
                      (chatProvider.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chatProvider.messages.length &&
                        chatProvider.isTyping) {
                      return _buildTypingIndicator(isDark);
                    }

                    final message = chatProvider.messages[index];
                    return ChatBubble(
                      message: message,
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('حذف الرسالة'),
                            content: const Text('هل تريد حذف هذه الرسالة؟'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: () {
                                  chatProvider.deleteMessage(message.id);
                                  Navigator.pop(context);
                                },
                                child: const Text('حذف'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.2, end: 0);
                  },
                );
              },
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, _) {
              if (chatProvider.lastReasoningTokens != null &&
                  chatProvider.isUsingGrok) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.psychology_outlined,
                            size: 16,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Reasoning Tokens: ${chatProvider.lastReasoningTokens}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ChatInput(
                      onSend: (message) {
                        chatProvider.sendMessage(message);
                      },
                      isEnabled: !chatProvider.isTyping,
                    ),
                  ],
                );
              }
              return ChatInput(
                onSend: (message) {
                  chatProvider.sendMessage(message);
                },
                isEnabled: !chatProvider.isTyping,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, right: 60),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(isDark)
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 400.ms)
                .then()
                .fadeOut(duration: 400.ms),
            const SizedBox(width: 4),
            _buildDot(isDark)
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .then()
                .fadeOut(duration: 400.ms),
            const SizedBox(width: 4),
            _buildDot(isDark)
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(delay: 400.ms, duration: 400.ms)
                .then()
                .fadeOut(duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool isDark) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        shape: BoxShape.circle,
      ),
    );
  }
}
