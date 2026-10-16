import '../models/disease_model.dart';
import '../models/symptom_model.dart';

class SymptomsRepository {
  // Dummy symptoms data
  static final List<Symptom> _symptoms = [
    Symptom(
      id: 's1',
      name: 'Headache',
      nameAr: 'صداع',
      category: 'Neurological',
      categoryAr: 'عصبي',
      severity: 'mild',
      iconEmoji: '🤕',
      description: 'Pain in the head or upper neck',
      descriptionAr: 'ألم في الرأس أو أعلى الرقبة',
    ),
    Symptom(
      id: 's2',
      name: 'Fever',
      nameAr: 'حمى',
      category: 'General',
      categoryAr: 'عام',
      severity: 'moderate',
      iconEmoji: '🌡️',
      description: 'Elevated body temperature',
      descriptionAr: 'ارتفاع درجة حرارة الجسم',
    ),
    Symptom(
      id: 's3',
      name: 'Cough',
      nameAr: 'سعال',
      category: 'Respiratory',
      categoryAr: 'تنفسي',
      severity: 'mild',
      iconEmoji: '😷',
      description: 'Sudden expulsion of air from lungs',
      descriptionAr: 'طرد مفاجئ للهواء من الرئتين',
    ),
    Symptom(
      id: 's4',
      name: 'Nausea',
      nameAr: 'غثيان',
      category: 'Digestive',
      categoryAr: 'هضمي',
      severity: 'moderate',
      iconEmoji: '🤢',
      description: 'Feeling of sickness with urge to vomit',
      descriptionAr: 'شعور بالمرض مع رغبة في التقيؤ',
    ),
    Symptom(
      id: 's5',
      name: 'Fatigue',
      nameAr: 'إرهاق',
      category: 'General',
      categoryAr: 'عام',
      severity: 'mild',
      iconEmoji: '😴',
      description: 'Extreme tiredness',
      descriptionAr: 'تعب شديد',
    ),
    Symptom(
      id: 's6',
      name: 'Sore Throat',
      nameAr: 'التهاب الحلق',
      category: 'Respiratory',
      categoryAr: 'تنفسي',
      severity: 'mild',
      iconEmoji: '🗣️',
      description: 'Pain or irritation in throat',
      descriptionAr: 'ألم أو تهيج في الحلق',
    ),
    Symptom(
      id: 's7',
      name: 'Runny Nose',
      nameAr: 'سيلان الأنف',
      category: 'Respiratory',
      categoryAr: 'تنفسي',
      severity: 'mild',
      iconEmoji: '🤧',
      description: 'Excess nasal discharge',
      descriptionAr: 'إفرازات أنفية زائدة',
    ),
    Symptom(
      id: 's8',
      name: 'Chest Pain',
      nameAr: 'ألم في الصدر',
      category: 'Cardiovascular',
      categoryAr: 'قلبي وعائي',
      severity: 'severe',
      iconEmoji: '💔',
      description: 'Discomfort in chest area',
      descriptionAr: 'عدم راحة في منطقة الصدر',
    ),
    Symptom(
      id: 's9',
      name: 'Shortness of Breath',
      nameAr: 'ضيق التنفس',
      category: 'Respiratory',
      categoryAr: 'تنفسي',
      severity: 'severe',
      iconEmoji: '😮‍💨',
      description: 'Difficulty breathing',
      descriptionAr: 'صعوبة في التنفس',
    ),
    Symptom(
      id: 's10',
      name: 'Dizziness',
      nameAr: 'دوخة',
      category: 'Neurological',
      categoryAr: 'عصبي',
      severity: 'moderate',
      iconEmoji: '😵',
      description: 'Feeling of lightheadedness',
      descriptionAr: 'شعور بخفة الرأس',
    ),
    Symptom(
      id: 's11',
      name: 'Abdominal Pain',
      nameAr: 'ألم في البطن',
      category: 'Digestive',
      categoryAr: 'هضمي',
      severity: 'moderate',
      iconEmoji: '🤰',
      description: 'Pain in stomach area',
      descriptionAr: 'ألم في منطقة المعدة',
    ),
    Symptom(
      id: 's12',
      name: 'Diarrhea',
      nameAr: 'إسهال',
      category: 'Digestive',
      categoryAr: 'هضمي',
      severity: 'moderate',
      iconEmoji: '🚽',
      description: 'Loose or watery stools',
      descriptionAr: 'براز رخو أو مائي',
    ),
    Symptom(
      id: 's13',
      name: 'Joint Pain',
      nameAr: 'ألم المفاصل',
      category: 'Musculoskeletal',
      categoryAr: 'عضلي هيكلي',
      severity: 'moderate',
      iconEmoji: '🦴',
      description: 'Pain in joints',
      descriptionAr: 'ألم في المفاصل',
    ),
    Symptom(
      id: 's14',
      name: 'Rash',
      nameAr: 'طفح جلدي',
      category: 'Dermatological',
      categoryAr: 'جلدي',
      severity: 'mild',
      iconEmoji: '🔴',
      description: 'Skin irritation or redness',
      descriptionAr: 'تهيج أو احمرار الجلد',
    ),
    Symptom(
      id: 's15',
      name: 'Loss of Appetite',
      nameAr: 'فقدان الشهية',
      category: 'General',
      categoryAr: 'عام',
      severity: 'mild',
      iconEmoji: '🍽️',
      description: 'Reduced desire to eat',
      descriptionAr: 'انخفاض الرغبة في الأكل',
    ),
  ];

  List<Symptom> getAllSymptoms() {
    return List.unmodifiable(_symptoms);
  }

  List<Symptom> getSymptomsByCategory(String category) {
    return _symptoms.where((s) => s.category == category).toList();
  }

  Symptom? getSymptomById(String id) {
    try {
      return _symptoms.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Disease> findDiseasesBySymptoms(List<Symptom> symptoms) {
    // Get all diseases from DiseaseRepository
    final allDiseases = DiseaseRepository().getAllDiseases();
    final List<Disease> matchingDiseases = [];

    for (var disease in allDiseases) {
      int matchCount = 0;
      for (var symptom in symptoms) {
        if (disease.symptoms.contains(symptom.name) ||
            disease.symptomsAr.contains(symptom.nameAr)) {
          matchCount++;
        }
      }

      // If at least 2 symptoms match, add to results
      if (matchCount >= 2) {
        matchingDiseases.add(disease);
      }
    }

    // Sort by number of matching symptoms (descending)
    matchingDiseases.sort((a, b) {
      int aMatches = 0;
      int bMatches = 0;
      for (var symptom in symptoms) {
        if (a.symptoms.contains(symptom.name)) aMatches++;
        if (b.symptoms.contains(symptom.name)) bMatches++;
      }
      return bMatches.compareTo(aMatches);
    });

    return matchingDiseases;
  }
}

class DiseaseRepository {
  static final List<Disease> _diseases = [
    Disease(
      id: 'd1',
      name: 'Common Cold',
      nameAr: 'نزلة البرد',
      description: 'A viral infection of the upper respiratory tract',
      descriptionAr: 'عدوى فيروسية في الجهاز التنفسي العلوي',
      symptoms: ['Runny Nose', 'Sore Throat', 'Cough', 'Headache', 'Fatigue'],
      symptomsAr: ['سيلان الأنف', 'التهاب الحلق', 'سعال', 'صداع', 'إرهاق'],
      treatments: [
        'Rest and hydration',
        'Over-the-counter pain relievers',
        'Throat lozenges',
        'Steam inhalation'
      ],
      treatmentsAr: [
        'الراحة وشرب السوائل',
        'مسكنات الألم بدون وصفة',
        'أقراص استحلاب للحلق',
        'استنشاق البخار'
      ],
      severity: 'low',
      category: 'Respiratory',
      iconEmoji: '🤧',
    ),
    Disease(
      id: 'd2',
      name: 'Flu (Influenza)',
      nameAr: 'الإنفلونزا',
      description:
          'A contagious respiratory illness caused by influenza viruses',
      descriptionAr: 'مرض تنفسي معدٍ ناتج عن فيروسات الإنفلونزا',
      symptoms: [
        'Fever',
        'Cough',
        'Sore Throat',
        'Fatigue',
        'Headache',
        'Joint Pain'
      ],
      symptomsAr: [
        'حمى',
        'سعال',
        'التهاب الحلق',
        'إرهاق',
        'صداع',
        'ألم المفاصل'
      ],
      treatments: [
        'Antiviral medications (if prescribed)',
        'Rest',
        'Plenty of fluids',
        'Fever reducers'
      ],
      treatmentsAr: [
        'أدوية مضادة للفيروسات (إذا وصفت)',
        'الراحة',
        'الكثير من السوائل',
        'خافضات الحرارة'
      ],
      severity: 'medium',
      category: 'Respiratory',
      iconEmoji: '🤒',
    ),
    Disease(
      id: 'd3',
      name: 'Migraine',
      nameAr: 'الصداع النصفي',
      description: 'A neurological condition causing intense headaches',
      descriptionAr: 'حالة عصبية تسبب صداعاً شديداً',
      symptoms: ['Headache', 'Nausea', 'Dizziness', 'Fatigue'],
      symptomsAr: ['صداع', 'غثيان', 'دوخة', 'إرهاق'],
      treatments: [
        'Pain relievers',
        'Rest in dark quiet room',
        'Cold compress',
        'Prescription migraine medications'
      ],
      treatmentsAr: [
        'مسكنات الألم',
        'الراحة في غرفة مظلمة هادئة',
        'كمادات باردة',
        'أدوية الصداع النصفي بوصفة طبية'
      ],
      severity: 'medium',
      category: 'Neurological',
      iconEmoji: '🤕',
    ),
    Disease(
      id: 'd4',
      name: 'Gastroenteritis',
      nameAr: 'التهاب المعدة والأمعاء',
      description: 'Inflammation of the digestive tract',
      descriptionAr: 'التهاب الجهاز الهضمي',
      symptoms: [
        'Nausea',
        'Diarrhea',
        'Abdominal Pain',
        'Fever',
        'Loss of Appetite'
      ],
      symptomsAr: ['غثيان', 'إسهال', 'ألم في البطن', 'حمى', 'فقدان الشهية'],
      treatments: [
        'Hydration with electrolytes',
        'Rest',
        'Bland diet (BRAT diet)',
        'Anti-nausea medication if needed'
      ],
      treatmentsAr: [
        'الترطيب بالمحاليل الملحية',
        'الراحة',
        'نظام غذائي خفيف',
        'أدوية مضادة للغثيان عند الحاجة'
      ],
      severity: 'medium',
      category: 'Digestive',
      iconEmoji: '🤢',
    ),
    Disease(
      id: 'd5',
      name: 'Hypertension',
      nameAr: 'ارتفاع ضغط الدم',
      description: 'High blood pressure condition',
      descriptionAr: 'حالة ارتفاع ضغط الدم',
      symptoms: ['Headache', 'Dizziness', 'Chest Pain', 'Shortness of Breath'],
      symptomsAr: ['صداع', 'دوخة', 'ألم في الصدر', 'ضيق التنفس'],
      treatments: [
        'Lifestyle changes',
        'Regular exercise',
        'Low-sodium diet',
        'Blood pressure medications'
      ],
      treatmentsAr: [
        'تغييرات في نمط الحياة',
        'ممارسة الرياضة بانتظام',
        'نظام غذائي قليل الملح',
        'أدوية خفض ضغط الدم'
      ],
      severity: 'high',
      category: 'Cardiovascular',
      iconEmoji: '❤️',
    ),
    Disease(
      id: 'd6',
      name: 'Asthma',
      nameAr: 'الربو',
      description:
          'Chronic respiratory condition causing breathing difficulties',
      descriptionAr: 'حالة تنفسية مزمنة تسبب صعوبة في التنفس',
      symptoms: ['Shortness of Breath', 'Cough', 'Chest Pain', 'Fatigue'],
      symptomsAr: ['ضيق التنفس', 'سعال', 'ألم في الصدر', 'إرهاق'],
      treatments: [
        'Inhalers (bronchodilators)',
        'Avoid triggers',
        'Corticosteroids',
        'Regular monitoring'
      ],
      treatmentsAr: [
        'أجهزة الاستنشاق',
        'تجنب المحفزات',
        'الكورتيكوستيرويدات',
        'المراقبة المنتظمة'
      ],
      severity: 'high',
      category: 'Respiratory',
      iconEmoji: '🫁',
    ),
    Disease(
      id: 'd7',
      name: 'Allergic Rhinitis',
      nameAr: 'التهاب الأنف التحسسي',
      description: 'Allergic inflammation of the nasal airways',
      descriptionAr: 'التهاب تحسسي في الممرات الأنفية',
      symptoms: ['Runny Nose', 'Headache', 'Fatigue', 'Sore Throat'],
      symptomsAr: ['سيلان الأنف', 'صداع', 'إرهاق', 'التهاب الحلق'],
      treatments: [
        'Antihistamines',
        'Nasal corticosteroids',
        'Avoid allergens',
        'Decongestants'
      ],
      treatmentsAr: [
        'مضادات الهيستامين',
        'بخاخات الأنف الستيرويدية',
        'تجنب مسببات الحساسية',
        'مزيلات الاحتقان'
      ],
      severity: 'low',
      category: 'Respiratory',
      iconEmoji: '🌼',
    ),
    Disease(
      id: 'd8',
      name: 'Arthritis',
      nameAr: 'التهاب المفاصل',
      description: 'Joint inflammation causing pain and stiffness',
      descriptionAr: 'التهاب المفاصل يسبب ألماً وتيبساً',
      symptoms: ['Joint Pain', 'Fatigue', 'Dizziness'],
      symptomsAr: ['ألم المفاصل', 'إرهاق', 'دوخة'],
      treatments: [
        'Anti-inflammatory medications',
        'Physical therapy',
        'Exercise',
        'Hot/cold therapy'
      ],
      treatmentsAr: [
        'أدوية مضادة للالتهاب',
        'العلاج الطبيعي',
        'التمارين الرياضية',
        'العلاج بالحرارة/البرودة'
      ],
      severity: 'medium',
      category: 'Musculoskeletal',
      iconEmoji: '🦴',
    ),
    Disease(
      id: 'd9',
      name: 'Eczema',
      nameAr: 'الأكزيما',
      description: 'Chronic skin condition causing inflammation and irritation',
      descriptionAr: 'حالة جلدية مزمنة تسبب التهاباً وتهيجاً',
      symptoms: ['Rash', 'Fatigue'],
      symptomsAr: ['طفح جلدي', 'إرهاق'],
      treatments: [
        'Moisturizers',
        'Topical corticosteroids',
        'Avoid irritants',
        'Cool compresses'
      ],
      treatmentsAr: [
        'المرطبات',
        'الكورتيكوستيرويدات الموضعية',
        'تجنب المهيجات',
        'الكمادات الباردة'
      ],
      severity: 'low',
      category: 'Dermatological',
      iconEmoji: '🔴',
    ),
    Disease(
      id: 'd10',
      name: 'Anxiety Disorder',
      nameAr: 'اضطراب القلق',
      description: 'Mental health condition characterized by excessive worry',
      descriptionAr: 'حالة صحية نفسية تتميز بالقلق المفرط',
      symptoms: ['Headache', 'Dizziness', 'Fatigue', 'Nausea'],
      symptomsAr: ['صداع', 'دوخة', 'إرهاق', 'غثيان'],
      treatments: [
        'Cognitive behavioral therapy',
        'Relaxation techniques',
        'Exercise',
        'Anti-anxiety medication if prescribed'
      ],
      treatmentsAr: [
        'العلاج السلوكي المعرفي',
        'تقنيات الاسترخاء',
        'التمارين الرياضية',
        'أدوية مضادة للقلق إذا وصفت'
      ],
      severity: 'medium',
      category: 'Mental Health',
      iconEmoji: '😰',
    ),
  ];

  List<Disease> getAllDiseases() {
    return List.unmodifiable(_diseases);
  }

  Disease? getDiseaseById(String id) {
    try {
      return _diseases.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Disease> getDiseasesByCategory(String category) {
    return _diseases.where((d) => d.category == category).toList();
  }

  List<Disease> searchDiseases(String query) {
    final lowerQuery = query.toLowerCase();
    return _diseases
        .where((d) =>
            d.name.toLowerCase().contains(lowerQuery) ||
            d.nameAr.contains(query) ||
            d.description.toLowerCase().contains(lowerQuery) ||
            d.descriptionAr.contains(query))
        .toList();
  }
}
