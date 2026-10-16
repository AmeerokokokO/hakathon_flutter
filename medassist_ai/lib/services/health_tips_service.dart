import '../data/models/health_tip_model.dart';

class HealthTipsService {
  static final List<HealthTip> _tips = [
    HealthTip(
      id: 'tip1',
      title: 'Drink Water',
      titleAr: 'اشرب الماء',
      content:
          'Drink at least 8 glasses of water daily to stay hydrated and maintain optimal body function.',
      contentAr:
          'اشرب ما لا يقل عن 8 أكواب من الماء يومياً للحفاظ على رطوبة الجسم ووظائفه',
      category: 'Nutrition',
      categoryAr: 'التغذية',
      iconEmoji: '💧',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip2',
      title: 'Exercise Regularly',
      titleAr: 'مارس الرياضة بانتظام',
      content:
          '30 minutes of moderate exercise daily can significantly improve your health and mood.',
      contentAr:
          '30 دقيقة من التمارين المعتدلة يومياً يمكن أن تحسن صحتك ومزاجك بشكل كبير',
      category: 'Exercise',
      categoryAr: 'الرياضة',
      iconEmoji: '🏃',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip3',
      title: 'Get Enough Sleep',
      titleAr: 'نم بشكل كافٍ',
      content:
          'Adults need 7-9 hours of quality sleep each night for optimal health.',
      contentAr:
          'يحتاج البالغون من 7 إلى 9 ساعات من النوم الجيد كل ليلة للصحة المثلى',
      category: 'Sleep',
      categoryAr: 'النوم',
      iconEmoji: '😴',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip4',
      title: 'Eat Fruits and Vegetables',
      titleAr: 'تناول الفواكه والخضروات',
      content:
          'Aim for at least 5 servings of fruits and vegetables daily for essential nutrients.',
      contentAr:
          'استهدف 5 حصص على الأقل من الفواكه والخضروات يومياً للحصول على العناصر الغذائية',
      category: 'Nutrition',
      categoryAr: 'التغذية',
      iconEmoji: '🥗',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip5',
      title: 'Practice Mindfulness',
      titleAr: 'مارس اليقظة الذهنية',
      content:
          'Take 10 minutes daily for meditation or deep breathing to reduce stress.',
      contentAr: 'خصص 10 دقائق يومياً للتأمل أو التنفس العميق لتقليل التوتر',
      category: 'Mental Health',
      categoryAr: 'الصحة النفسية',
      iconEmoji: '🧘',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip6',
      title: 'Limit Screen Time',
      titleAr: 'قلل وقت الشاشة',
      content: 'Reduce screen time before bed to improve sleep quality.',
      contentAr: 'قلل وقت الشاشة قبل النوم لتحسين جودة النوم',
      category: 'Lifestyle',
      categoryAr: 'نمط الحياة',
      iconEmoji: '📱',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip7',
      title: 'Wash Your Hands',
      titleAr: 'اغسل يديك',
      content:
          'Wash hands frequently with soap for at least 20 seconds to prevent infections.',
      contentAr:
          'اغسل يديك بشكل متكرر بالصابون لمدة 20 ثانية على الأقل لمنع العدوى',
      category: 'Hygiene',
      categoryAr: 'النظافة',
      iconEmoji: '🧼',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip8',
      title: 'Take Breaks',
      titleAr: 'خذ فترات راحة',
      content:
          'Take regular breaks when working to prevent eye strain and fatigue.',
      contentAr: 'خذ فترات راحة منتظمة أثناء العمل لمنع إجهاد العين والتعب',
      category: 'Lifestyle',
      categoryAr: 'نمط الحياة',
      iconEmoji: '⏰',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip9',
      title: 'Maintain Posture',
      titleAr: 'حافظ على وضعية جيدة',
      content:
          'Sit and stand with proper posture to prevent back and neck pain.',
      contentAr: 'اجلس وقف بوضعية سليمة لمنع آلام الظهر والرقبة',
      category: 'Exercise',
      categoryAr: 'الرياضة',
      iconEmoji: '🪑',
      date: DateTime.now(),
    ),
    HealthTip(
      id: 'tip10',
      title: 'Stay Social',
      titleAr: 'ابقَ اجتماعياً',
      content:
          'Maintain social connections for better mental and emotional health.',
      contentAr: 'حافظ على الروابط الاجتماعية لصحة نفسية وعاطفية أفضل',
      category: 'Mental Health',
      categoryAr: 'الصحة النفسية',
      iconEmoji: '👥',
      date: DateTime.now(),
    ),
  ];

  List<HealthTip> getDailyTips({int count = 3}) {
    final shuffled = List<HealthTip>.from(_tips)..shuffle();
    return shuffled.take(count).toList();
  }

  List<HealthTip> getAllTips() {
    return List.unmodifiable(_tips);
  }

  List<HealthTip> getTipsByCategory(String category) {
    return _tips.where((tip) => tip.category == category).toList();
  }

  HealthTip? getTipById(String id) {
    try {
      return _tips.firstWhere((tip) => tip.id == id);
    } catch (e) {
      return null;
    }
  }
}
