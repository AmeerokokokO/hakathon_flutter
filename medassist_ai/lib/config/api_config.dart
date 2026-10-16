class ApiConfig {
  // OpenRouter Configuration
  static const String openRouterApiKey = 'YOUR_OPENROUTER_API_KEY_HERE';
  static const String openRouterBaseUrl = 'https://openrouter.ai/api/v1';
  static const String grokModel = 'x-ai/grok-4.1-fast';

  // Gemini Configuration (existing key)
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  static const String geminiModel = 'gemini-1.5-flash';

  // Model Types
  static const String modelTypeGemini = 'gemini';
  static const String modelTypeGrok = 'grok';

  // Medical Context for AI (shared across all models)
  static const String medicalContext = '''
أنت مساعد طبي ذكي متخصص باللغة العربية. دورك:

1. تقديم معلومات طبية دقيقة وموثوقة بلغة عربية واضحة وبسيطة
2. الرد على الأسئلة الصحية والطبية بطريقة مفهومة للجميع
3. تقديم نصائح صحية عامة ومعلومات عن الأعراض والأمراض
4. شرح المصطلحات الطبية بطريقة مبسطة
5. تذكير المستخدم دائماً بأهمية استشارة الطبيب المختص

قواعد مهمة:
- لا تقدم تشخيصاً نهائياً للأمراض
- دائماً أكد على ضرورة استشارة طبيب مختص
- إذا كانت الحالة طارئة، انصح بالتوجه للطوارئ فوراً
- قدم معلومات عامة وموثوقة فقط
- استخدم لغة عربية فصحى سهلة الفهم

أنهِ كل إجابة بتذكير مهذب باستشارة الطبيب المختص.
''';
}
