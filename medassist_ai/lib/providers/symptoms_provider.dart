import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../data/models/symptom_model.dart';
import '../data/models/disease_model.dart';
import '../data/repositories/symptoms_repository.dart';
import '../services/symptoms_analysis_service.dart';

class SymptomsProvider with ChangeNotifier {
  final SymptomsRepository _repository = SymptomsRepository();
  final SymptomsAnalysisService _aiService = SymptomsAnalysisService();

  final List<Symptom> _selectedSymptoms = [];
  int _currentStep = 0;
  String _additionalInfo = '';
  List<Disease> _possibleDiseases = [];
  bool _isAnalyzing = false;

  // AI Analysis results
  String _aiAnalysis = '';
  List<String> _homCareTips = [];
  String _whenToSeeDoctor = '';
  String _disclaimer = '';
  String _currentModel = ApiConfig.modelTypeGrok; // Default to Grok

  List<Symptom> get selectedSymptoms => List.unmodifiable(_selectedSymptoms);
  int get currentStep => _currentStep;
  String get additionalInfo => _additionalInfo;
  List<Disease> get possibleDiseases => List.unmodifiable(_possibleDiseases);
  bool get isAnalyzing => _isAnalyzing;

  // AI Analysis getters
  String get aiAnalysis => _aiAnalysis;
  List<String> get homeCareTips => List.unmodifiable(_homCareTips);
  String get whenToSeeDoctor => _whenToSeeDoctor;
  String get disclaimer => _disclaimer;
  String get currentModel => _currentModel;

  List<Symptom> get allSymptoms => _repository.getAllSymptoms();

  void toggleSymptom(Symptom symptom) {
    if (_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.remove(symptom);
    } else {
      _selectedSymptoms.add(symptom);
    }
    notifyListeners();
  }

  void setAdditionalInfo(String info) {
    _additionalInfo = info;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void setModel(String modelType) {
    if (modelType == ApiConfig.modelTypeGemini ||
        modelType == ApiConfig.modelTypeGrok) {
      _currentModel = modelType;
      notifyListeners();
    }
  }

  Future<void> analyzeSymptoms() async {
    _isAnalyzing = true;
    notifyListeners();

    try {
      // Use AI to analyze symptoms
      final result = await _aiService.analyzeSymptoms(
        symptoms: _selectedSymptoms,
        additionalInfo: _additionalInfo,
        modelType: _currentModel,
      );

      if (result['success'] == true) {
        final data = result['data'] as Map<String, dynamic>;

        // Store AI analysis results
        _aiAnalysis = data['analysis'] ?? '';
        _homCareTips = List<String>.from(data['home_care_tips'] ?? []);
        _whenToSeeDoctor = data['when_to_see_doctor'] ?? '';
        _disclaimer = data['disclaimer'] ?? 'يُرجى استشارة طبيب مختص.';

        // Convert AI diseases to Disease objects
        _possibleDiseases = [];
        final aiDiseases = data['possible_diseases'] as List<dynamic>? ?? [];

        for (var i = 0; i < aiDiseases.length; i++) {
          final disease = aiDiseases[i] as Map<String, dynamic>;
          _possibleDiseases.add(Disease(
            id: 'ai_disease_$i',
            name: disease['name_ar'] ?? 'غير محدد',
            nameAr: disease['name_ar'] ?? 'غير محدد',
            category: 'AI Analysis',
            severity: disease['severity'] ?? 'medium',
            iconEmoji: _getEmojiForSeverity(disease['severity'] ?? 'medium'),
            description: disease['description_ar'] ?? '',
            descriptionAr: disease['description_ar'] ?? '',
            symptoms: _selectedSymptoms.map((s) => s.id).toList(),
            symptomsAr: _selectedSymptoms.map((s) => s.nameAr).toList(),
            treatments: [],
            treatmentsAr: [],
          ));
        }
      } else {
        // Fallback to simple analysis if AI fails
        _aiAnalysis =
            'تعذر التحليل بالذكاء الاصطناعي. تم استخدام التحليل البسيط.';
        _possibleDiseases =
            _repository.findDiseasesBySymptoms(_selectedSymptoms);
        _homCareTips = ['الراحة الكافية', 'شرب السوائل', 'مراقبة الأعراض'];
        _whenToSeeDoctor = 'إذا استمرت الأعراض أو ازدادت سوءاً.';
        _disclaimer = 'يُرجى استشارة طبيب مختص.';
      }
    } catch (e) {
      // Fallback on error
      _aiAnalysis = 'حدث خطأ في التحليل: ${e.toString()}';
      _possibleDiseases = _repository.findDiseasesBySymptoms(_selectedSymptoms);
      _homCareTips = ['استشر طبيباً للحصول على تشخيص دقيق'];
      _whenToSeeDoctor = 'في أقرب وقت ممكن';
      _disclaimer = 'يُرجى استشارة طبيب مختص.';
    }

    _isAnalyzing = false;
    _currentStep = 2; // Move to results step
    notifyListeners();
  }

  String _getEmojiForSeverity(String severity) {
    switch (severity) {
      case 'low':
        return '🟢';
      case 'medium':
        return '🟡';
      case 'high':
        return '🔴';
      default:
        return '⚪';
    }
  }

  void reset() {
    _selectedSymptoms.clear();
    _currentStep = 0;
    _additionalInfo = '';
    _possibleDiseases.clear();
    _isAnalyzing = false;
    _aiAnalysis = '';
    _homCareTips.clear();
    _whenToSeeDoctor = '';
    _disclaimer = '';
    notifyListeners();
  }
}
