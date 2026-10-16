import 'dart:convert';
import '../config/api_config.dart';
import '../data/models/symptom_model.dart';
import 'ai_chat_service.dart';
import 'openrouter_service.dart';

class SymptomsAnalysisService {
  final AIChatService _geminiService = AIChatService();
  final OpenRouterService _grokService = OpenRouterService();

  /// Analyze symptoms using AI (Gemini or Grok)
  Future<Map<String, dynamic>> analyzeSymptoms({
    required List<Symptom> symptoms,
    required String additionalInfo,
    String modelType = 'gemini', // 'gemini' or 'grok'
  }) async {
    try {
      // Build the prompt
      final prompt = _buildAnalysisPrompt(symptoms, additionalInfo);

      // Get response from selected AI model
      String response;
      if (modelType == ApiConfig.modelTypeGrok) {
        final result = await _grokService.sendMessage(prompt, stream: false);
        if (result['success'] != true) {
          throw Exception(result['error'] ?? 'فشل الاتصال بـ Grok');
        }
        response = result['response'] ?? '';
      } else {
        response = await _geminiService.sendMessage(prompt);
      }

      // Parse JSON response
      final analysisResult = _parseAIResponse(response);

      return {
        'success': true,
        'data': analysisResult,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'حدث خطأ في تحليل الأعراض: ${e.toString()}',
      };
    }
  }

  String _buildAnalysisPrompt(List<Symptom> symptoms, String additionalInfo) {
    final symptomsList =
        symptoms.map((s) => '- ${s.nameAr} (${s.categoryAr})').join('\n');

    return '''
أنت طبيب استشاري متخصص. المريض يعاني من الأعراض التالية:

$symptomsList

${additionalInfo.isNotEmpty ? 'معلومات إضافية من المريض:\n$additionalInfo\n' : ''}

يرجى تقديم تحليل طبي شامل ومفصل يتضمن:

1. **تحليل عام للحالة**: وصف شامل للحالة بناءً على الأعراض المذكورة
2. **الأمراض المحتملة**: قائمة بالأمراض المحتملة مع احتمالية كل منها ووصف مختصر
3. **نصائح العناية المنزلية**: نصائح عملية للعناية بالحالة في المنزل
4. **متى يجب مراجعة الطبيب**: الحالات التي تستدعي زيارة فورية للطبيب

**مهم جداً**: 
- الرد يجب أن يكون بصيغة JSON فقط بدون أي نص إضافي
- استخدم اللغة العربية في جميع الحقول
- لا تضع أي نص قبل أو بعد JSON

الصيغة المطلوبة:
{
  "analysis": "تحليل شامل للحالة بناءً على الأعراض...",
  "possible_diseases": [
    {
      "name_ar": "اسم المرض بالعربية",
      "probability": "high",
      "description_ar": "وصف مختصر للمرض وعلاقته بالأعراض",
      "severity": "medium"
    }
  ],
  "home_care_tips": [
    "نصيحة 1 للعناية المنزلية",
    "نصيحة 2 للعناية المنزلية"
  ],
  "when_to_see_doctor": "متى يجب زيارة الطبيب فوراً...",
  "disclaimer": "هذه معلومات استرشادية فقط. يُرجى استشارة طبيب مختص للتشخيص الدقيق والعلاج المناسب."
}

ملاحظات:
- probability يمكن أن تكون: "high", "medium", "low"
- severity يمكن أن تكون: "low", "medium", "high"
- قدم على الأقل 2-4 أمراض محتملة
- قدم 3-5 نصائح للعناية المنزلية
''';
  }

  Map<String, dynamic> _parseAIResponse(String response) {
    try {
      // Try to extract JSON from response
      String jsonString = response.trim();

      // Remove markdown code blocks if present
      if (jsonString.contains('```json')) {
        final startIndex = jsonString.indexOf('```json') + 7;
        final endIndex = jsonString.lastIndexOf('```');
        if (endIndex > startIndex) {
          jsonString = jsonString.substring(startIndex, endIndex).trim();
        }
      } else if (jsonString.contains('```')) {
        final startIndex = jsonString.indexOf('```') + 3;
        final endIndex = jsonString.lastIndexOf('```');
        if (endIndex > startIndex) {
          jsonString = jsonString.substring(startIndex, endIndex).trim();
        }
      }

      // Find JSON object bounds
      final jsonStart = jsonString.indexOf('{');
      final jsonEnd = jsonString.lastIndexOf('}');

      if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
        jsonString = jsonString.substring(jsonStart, jsonEnd + 1);
      }

      final Map<String, dynamic> parsed = jsonDecode(jsonString);

      // Validate required fields
      if (!parsed.containsKey('analysis') ||
          !parsed.containsKey('possible_diseases') ||
          !parsed.containsKey('home_care_tips') ||
          !parsed.containsKey('when_to_see_doctor')) {
        throw FormatException('Missing required fields in AI response');
      }

      return parsed;
    } catch (e) {
      // If parsing fails, return a structured error response
      return {
        'analysis':
            'تعذر تحليل الأعراض بشكل كامل. يرجى المحاولة مرة أخرى أو استشارة طبيب.',
        'possible_diseases': [
          {
            'name_ar': 'غير محدد',
            'probability': 'medium',
            'description_ar':
                'لم نتمكن من تحديد المرض بدقة. يُنصح بمراجعة الطبيب.',
            'severity': 'medium',
          }
        ],
        'home_care_tips': [
          'الراحة الكافية',
          'شرب السوائل بكثرة',
          'مراقبة الأعراض',
        ],
        'when_to_see_doctor':
            'إذا استمرت الأعراض أو ازدادت سوءاً، يُرجى مراجعة الطبيب فوراً.',
        'disclaimer': 'هذه معلومات استرشادية فقط. يُرجى استشارة طبيب مختص.',
        'parse_error': e.toString(),
      };
    }
  }
}
