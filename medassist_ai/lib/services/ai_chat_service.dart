import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AIChatService {
  String? _apiKey;
  GenerativeModel? _model;

  AIChatService() {
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('gemini_api_key');

    // استخدام المفتاح المقدم من المستخدم إذا لم يكن هناك مفتاح محفوظ
    if (_apiKey == null || _apiKey!.isEmpty) {
      if (ApiConfig.geminiApiKey.isNotEmpty && ApiConfig.geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE') {
        _apiKey = ApiConfig.geminiApiKey;
        await prefs.setString('gemini_api_key', _apiKey!);
      }
    }

    if (_apiKey != null && _apiKey!.isNotEmpty) {
      _initializeModel();
    }
  }

  void _initializeModel() {
    if (_apiKey == null || _apiKey!.isEmpty) return;

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey!,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      safetySettings: [
        SafetySetting(
          HarmCategory.harassment,
          HarmBlockThreshold.medium,
        ),
        SafetySetting(
          HarmCategory.hateSpeech,
          HarmBlockThreshold.medium,
        ),
        SafetySetting(
          HarmCategory.sexuallyExplicit,
          HarmBlockThreshold.medium,
        ),
        SafetySetting(
          HarmCategory.dangerousContent,
          HarmBlockThreshold.medium,
        ),
      ],
    );
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', key);
    _initializeModel();
  }

  Future<String?> getApiKey() async {
    if (_apiKey != null) return _apiKey;
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('gemini_api_key');
    return _apiKey;
  }

  bool get hasApiKey => _apiKey != null && _apiKey!.isNotEmpty;

  Future<String> sendMessage(String message) async {
    // If no API key, return mock response
    if (!hasApiKey || _model == null) {
      return _getMockResponse(message);
    }

    try {
      // إنشاء prompt مع السياق الطبي
      final prompt = '''
${ApiConfig.medicalContext}

المستخدم يسأل: $message

يرجى الإجابة بشكل واضح ومفصل باللغة العربية، مع تقديم معلومات طبية موثوقة ونصائح عامة.
''';

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return _getErrorResponse('لم أتمكن من الحصول على رد من النموذج.');
      }
    } on GenerativeAIException catch (e) {
      return _handleGeminiError(e);
    } catch (e) {
      return _getErrorResponse(
          'حدث خطأ أثناء الاتصال بالخدمة: ${e.toString()}');
    }
  }

  String _handleGeminiError(GenerativeAIException error) {
    if (error.message.contains('API_KEY_INVALID')) {
      return '''
⚠️ خطأ في مفتاح API

مفتاح API غير صالح. يرجى:
1. التحقق من المفتاح
2. التأكد من تفعيل Gemini API
3. إدخال مفتاح جديد من الإعدادات

للحصول على مفتاح جديد:
https://aistudio.google.com/app/apikey
''';
    } else if (error.message.contains('RATE_LIMIT_EXCEEDED')) {
      return '''
⏰ تجاوزت الحد المسموح

لقد تجاوزت عدد الطلبات المسموح بها. يرجى:
- الانتظار قليلاً والمحاولة مرة أخرى
- حد الاستخدام المجاني: 15 طلب/دقيقة

في الوقت الحالي، يمكنني تقديم معلومات عامة:
${_getMockResponse('معلومات عامة')}
''';
    } else if (error.message.contains('SAFETY')) {
      return '''
🛡️ تنبيه أمان المحتوى

عذراً، لا يمكنني الإجابة على هذا السؤال لأسباب تتعلق بسياسة السلامة.

يرجى صياغة السؤال بطريقة أخرى أو طرح سؤال طبي عام.
''';
    } else {
      return _getErrorResponse('خطأ في الاتصال: ${error.message}');
    }
  }

  String _getErrorResponse(String errorMessage) {
    return '''
❌ $errorMessage

يمكنني تقديم معلومات طبية عامة في الوقت الحالي.

كيف يمكنني مساعدتك؟
''';
  }

  String _getMockResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('صداع') || lowerMessage.contains('headache')) {
      return '''يمكن أن يكون الصداع ناتجاً عن عدة أسباب:

• الجفاف - تأكد من شرب كمية كافية من الماء
• الإجهاد والتوتر - حاول الاسترخاء والراحة
• قلة النوم - احرص على نوم كافٍ (7-8 ساعات)
• مشاكل في النظر - قد تحتاج لفحص النظر
• التهاب الجيوب الأنفية
• الصداع النصفي (الشقيقة)

متى تستشير الطبيب:
⚠️ إذا كان الصداع مفاجئاً وشديداً جداً
⚠️ إذا صاحبه حمى أو تصلب في الرقبة
⚠️ إذا كان متكرراً ويزداد سوءاً

💊 ملاحظة: هذه معلومات عامة فقط. يُرجى استشارة طبيبك للتشخيص الدقيق والعلاج المناسب.

ℹ️ للحصول على ردود ذكية أكثر تفصيلاً، قم بإضافة Gemini API Key من الإعدادات.''';
    }

    if (lowerMessage.contains('حرارة') ||
        lowerMessage.contains('fever') ||
        lowerMessage.contains('حمى')) {
      return '''الحمى عادة ما تكون علامة على أن الجسم يحارب عدوى:

🌡️ درجات الحرارة:
• طبيعية: 36.5-37.5°C
• حمى خفيفة: 37.5-38°C
• حمى متوسطة: 38-39°C
• حمى شديدة: أكثر من 39°C

نصائح عامة:
• اشرب الكثير من السوائل
• خذ قسطاً من الراحة
• استخدم كمادات باردة
• تناول خافض للحرارة حسب الحاجة

⚕️ راجع الطبيب فوراً إذا:
- الحرارة أعلى من 39.5°C
- استمرت أكثر من 3 أيام
- ظهرت أعراض أخرى مقلقة (طفح، تصلب الرقبة، صعوبة التنفس)
- الحمى عند الأطفال دون 3 أشهر

🏥 للحصول على نصائح طبية شخصية، استشر الطبيب المختص.''';
    }

    if (lowerMessage.contains('نوم') ||
        lowerMessage.contains('sleep') ||
        lowerMessage.contains('أرق')) {
      return '''نصائح لتحسين جودة النوم:

🌙 روتين النوم:
• نم واستيقظ في نفس الوقت يومياً
• اجعل غرفة النوم مظلمة وباردة وهادئة
• تجنب الشاشات قبل النوم بساعة
• اقرأ كتاباً أو استمع لموسيقى هادئة

☕ تجنب:
• الكافيين بعد الظهر
• الوجبات الثقيلة قبل النوم
• القيلولة الطويلة نهاراً (لا تزيد عن 30 دقيقة)
• التمارين الرياضية القوية قبل النوم

😌 جرّب:
• تمارين الاسترخاء والتأمل
• حمام دافئ قبل النوم
• تمارين التنفس العميق

⏰ معظم البالغين يحتاجون 7-9 ساعات نوم يومياً.

إذا استمرت مشاكل النوم لأكثر من أسبوعين، استشر طبيباً.''';
    }

    // Default response
    return '''مرحباً! 👋

أنا مساعدك الطبي الذكي. يمكنني المساعدة في:

💡 معلومات عن الأعراض الشائعة
🏥 نصائح صحية عامة
🚑 الإسعافات الأولية
💪 نمط حياة صحي
💊 معلومات عن الأدوية الشائعة

🔑 للحصول على ردود أكثر ذكاءً وتفصيلاً:
قم بإضافة Gemini API Key من إعدادات التطبiق!

🏥 تذكير مهم: المعلومات المقدمة للأغراض التعليمية فقط ولا تغني عن استشارة الطبيب المختص.

كيف يمكنني مساعدتك اليوم؟''';
  }
}
