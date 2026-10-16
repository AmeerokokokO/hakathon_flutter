import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  // اختبار Gemini API
  const apiKey = 'YOUR_GEMINI_API_KEY_HERE';

  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );

  print('🧪 اختبار الاتصال بـ Gemini API...\n');

  try {
    final prompt = '''
أنت مساعد طبي ذكي باللغة العربية.

المستخدم يسأل: ما أعراض نزلة البرد؟

أجب بشكل واضح ومختصر.
''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    if (response.text != null) {
      print('✅ نجح الاتصال!\n');
      print('📝 رد Gemini:\n');
      print(response.text);
    } else {
      print('❌ لم يتم الحصول على رد');
    }
  } catch (e) {
    print('❌ خطأ: $e');
  }
}
