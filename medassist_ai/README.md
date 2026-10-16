# MedAssist AI - مساعدك الطبي الذكي

<div align="center">
  <h3>🏥 تطبيق طبي ذكي مبني بـ Flutter</h3>
  <p>مساعد طبي يوفر معلومات موثوقة، تحليل أعراض، ودردشة مع الذكاء الاصطناعي</p>
</div>

---

## ✨ المميزات

### 🤖 الذكاء الاصطناعي
- دردشة تفاعلية شبيهة بـ ChatGPT مع طابع طبي
- ردود ذكية على الاستفسارات الصحية
- دعم API مخصص (OpenAI, Google AI, etc.)
- نظام Mock للاختبار بدون API

### 🔍 تحليل الأعراض
- اختيار تفاعلي للأعراض
- نظام Stepper متقدم من 3 خطوات
- مطابقة ذكية للأمراض المحتملة
- نتائج مفصلة مع توصيات

### 📚 قاعدة بيانات طبية
- 10+ أمراض شائعة مع معلومات كاملة
- 15+ عرض طبي مصنف
- 30+ نصيحة صحية يومية
- بحث متقدم وتصنيف

### 🎨 تصميم عصري
- Material 3 Design
- دعم كامل للوضع الداكن / الفاتح
- Neumorphic Cards
- Animations سلسة (Fade, Slide, Scale, Hero)
- Clean Minimalist UI

### 🌍 دعم متعدد اللغات
- واجهة عربية كاملة
- بيانات ثنائية اللغة (عربي/إنجليزي)
- خطوط Google Fonts (Cairo / Inter)

---

## 📱 الشاشات

1. **Splash Screen** - شاشة بداية متحركة
2. **Home Dashboard** - لوحة تحكم رئيسية
3. **AI Chat** - محادثة مع الذكاء الاصطناعي
4. **Symptoms Analysis** - تحليل الأعراض
5. **Disease List** - قائمة الأمراض
6. **Disease Details** - تفاصيل المرض
7. **Profile** - الملف الشخصي
8. **Settings** - الإعدادات

---

## 🛠️ التقنيات المستخدمة

### Dependencies
```yaml
- provider: ^6.1.1              # State Management
- hive_flutter: ^1.1.0          # Local Storage
- shared_preferences: ^2.2.2    # Settings Storage
- lottie: ^3.0.0               # Animations
- flutter_svg: ^2.0.9          # SVG Support
- google_fonts: ^6.1.0         # Typography
- flutter_animate: ^4.3.0      # Advanced Animations
- dio: ^5.4.0                  # HTTP Client
- intl: ^0.18.1                # Internationalization
- uuid: ^4.3.3                 # Unique IDs
```

### Architecture
```
lib/
├── config/          # Theme, Colors, Routes
├── core/            # Constants, Utils, Common Widgets
├── data/            # Models, Repositories, Local Storage
├── services/        # AI Chat, Health Tips
├── providers/       # State Management (Provider)
└── presentation/    # UI Screens & Widgets
```

---

## 🚀 Quick Start

### 1. التثبيت
```bash
# Clone the repository
cd d:\Android_Studio\gavite\hakathon_flutter\medassist_ai

# Get dependencies
flutter pub get

# Run the app
flutter run
```

### 2. إعداد API (اختياري)
1. افتح التطبيق واذهب إلى **الإعدادات**
2. أدخل **API Endpoint** (مثال: OpenAI, Google AI)
3. أدخل **API Key** الخاص بك
4. احفظ وابدأ الدردشة

**ملاحظة**: التطبيق يعمل بدون API باستخدام Mock Responses

---

## 🎨 نمط التصميم

### الألوان
```dart
Primary:     #1E88E5  (Medical Blue)
Secondary:   #43A047  (Health Green)
Accent:      #00C9A7  (Teal)
Background:  #F8FBFF  (Light) / #0F172A (Dark)
```

### Typography
- **Headers**: Cairo (Arabic support)
- **Body**: Inter (Modern, clean)

### UI Patterns
- Neumorphic Cards
- Gradient Backgrounds
- Smooth Animations
- Clean White Space
- Modern Icons & Emojis

---

## 📊 البيانات الوهمية

### الأمراض (10)
- نزلة البرد
- الإنفلونزا
- الصداع النصفي
- التهاب المعدة والأمعاء
- ارتفاع ضغط الدم
- الربو
- التهاب الأنف التحسسي
- التهاب المفاصل
- الأكزيما
- اضطراب القلق

### الأعراض (15)
مصنفة حسب: عصبي، تنفسي، هضمي، عام، قلبي، عضلي، جلدي

### النصائح الصحية (10)
موزعة على: تغذية، رياضة، نوم، صحة نفسية، نظافة

---

## 🔐 الخصوصية والأمان

- جميع البيانات محلية (Hive + SharedPreferences)
- API Keys محفوظة بشكل آمن محلياً
- لا يتم إرسال بيانات لخوادم خارجية (إلا AI API)
- معلومات طبية للأغراض التعليمية فقط

---

## ⚠️ تنويه مهم

هذا التطبيق يوفر معلومات صحية عامة للأغراض التعليمية فقط ولا يُغني عن استشارة الطبيب المختص. يُرجى دائماً استشارة مقدم الرعاية الصحية للتشخيص والعلاج الدقيق.

---

## 📝 الترخيص

MIT License - مفتوح المصدر للاستخدام التعليمي

---

## 👨‍💻 التطوير

تم بناء هذا التطبيق كمشروع تعليمي لإظهار:
- Clean Architecture في Flutter
- State Management بـ Provider
- UI/UX عصري وجذاب
- Animations متقدمة
- تكامل AI APIs
- Local Storage
- Material 3 Design

---

## 📞 الدعم

للأسئلة أو المشاكل، يمكنك فتح Issue في المستودع أو التواصل عبر البريد الإلكتروني.

---

<div align="center">
  <p>صُنع بـ ❤️ باستخدام Flutter</p>
  <p>MedAssist AI © 2024</p>
</div>
