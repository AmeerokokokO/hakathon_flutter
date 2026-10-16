import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/api_config.dart';

class OpenRouterService {
  final Dio _dio;
  String? _apiKey;

  OpenRouterService({String? apiKey})
      : _apiKey = apiKey ?? ApiConfig.openRouterApiKey,
        _dio = Dio(BaseOptions(
          baseUrl: ApiConfig.openRouterBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  void setApiKey(String key) {
    _apiKey = key;
  }

  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  /// Send message to Grok with streaming support
  Future<Map<String, dynamic>> sendMessage(
    String message, {
    bool stream = true,
    Function(String)? onChunk,
    Function(int?)? onReasoningTokens,
  }) async {
    if (!hasApiKey) {
      throw Exception('OpenRouter API key is not set');
    }

    try {
      final requestData = {
        'model': ApiConfig.grokModel,
        'messages': [
          {
            'role': 'system',
            'content': ApiConfig.medicalContext,
          },
          {
            'role': 'user',
            'content': message,
          }
        ],
        'stream': stream,
        'stream_options': {
          'include_usage': true,
        },
        'provider': {
          'sort': 'throughput',
        }
      };

      if (stream && onChunk != null) {
        return await _streamResponse(requestData, onChunk, onReasoningTokens);
      } else {
        return await _normalResponse(requestData);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        'success': false,
        'error': 'حدث خطأ غير متوقع: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> _streamResponse(
    Map<String, dynamic> requestData,
    Function(String) onChunk,
    Function(int?)? onReasoningTokens,
  ) async {
    final response = await _dio.post(
      '/chat/completions',
      data: requestData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://medassist-ai.app',
          'X-Title': 'MedAssist AI',
        },
        responseType: ResponseType.stream,
      ),
    );

    final completer = Completer<Map<String, dynamic>>();
    String fullResponse = '';
    int? reasoningTokens;
    StringBuffer buffer = StringBuffer();

    response.data.stream.listen(
      (List<int> chunk) {
        // Decode the chunk and add to buffer
        final decoded = utf8.decode(chunk, allowMalformed: true);
        buffer.write(decoded);

        // Process complete lines
        final lines = buffer.toString().split('\n');

        // Keep the last incomplete line in the buffer
        buffer.clear();
        if (lines.isNotEmpty && !lines.last.endsWith('\n')) {
          buffer.write(lines.last);
          lines.removeLast();
        }

        // Process each complete line
        for (final line in lines) {
          final trimmedLine = line.trim();
          if (trimmedLine.startsWith('data: ')) {
            final data = trimmedLine.substring(6);
            if (data == '[DONE]') continue;

            try {
              final json = jsonDecode(data);
              final content = json['choices']?[0]?['delta']?['content'];

              if (content != null && content.isNotEmpty) {
                fullResponse += content;
                onChunk(content);
              }

              // Check for usage information (comes in final chunk)
              if (json['usage'] != null) {
                reasoningTokens = json['usage']['reasoning_tokens'];
                if (onReasoningTokens != null && reasoningTokens != null) {
                  onReasoningTokens(reasoningTokens);
                }
              }
            } catch (e) {
              // Skip invalid JSON
            }
          }
        }
      },
      onDone: () {
        completer.complete({
          'success': true,
          'response': fullResponse,
          'reasoning_tokens': reasoningTokens,
        });
      },
      onError: (error) {
        completer.complete({
          'success': false,
          'error': 'خطأ في الاتصال: ${error.toString()}',
        });
      },
    );

    return completer.future;
  }

  Future<Map<String, dynamic>> _normalResponse(
      Map<String, dynamic> requestData) async {
    final response = await _dio.post(
      '/chat/completions',
      data: requestData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'https://medassist-ai.app',
          'X-Title': 'MedAssist AI',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final content = data['choices']?[0]?['message']?['content'] ?? '';
      final reasoningTokens = data['usage']?['reasoning_tokens'];

      return {
        'success': true,
        'response': content,
        'reasoning_tokens': reasoningTokens,
      };
    } else {
      return {
        'success': false,
        'error': 'فشل الاتصال بالخادم: ${response.statusCode}',
      };
    }
  }

  Map<String, dynamic> _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return {
        'success': false,
        'error': '⏰ انتهى وقت الاتصال. يرجى المحاولة مرة أخرى.',
      };
    }

    if (error.type == DioExceptionType.connectionError) {
      return {
        'success': false,
        'error': '🌐 خطأ في الاتصال بالإنترنت. تحقق من اتصالك.',
      };
    }

    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      final errorData = error.response!.data;

      if (statusCode == 401) {
        return {
          'success': false,
          'error':
              '⚠️ مفتاح API غير صالح. يرجى التحقق من المفتاح في الإعدادات.',
        };
      }

      if (statusCode == 429) {
        return {
          'success': false,
          'error': '⏰ تجاوزت الحد المسموح من الطلبات. يرجى الانتظار قليلاً.',
        };
      }

      return {
        'success': false,
        'error': 'خطأ من الخادم: ${errorData.toString()}',
      };
    }

    return {
      'success': false,
      'error': 'حدث خطأ: ${error.message}',
    };
  }

  /// Test the connection to OpenRouter
  Future<bool> testConnection() async {
    try {
      final result = await sendMessage(
        'اختبار الاتصال',
        stream: false,
      );
      return result['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
