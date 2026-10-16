import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../providers/symptoms_provider.dart';
import '../../../data/models/symptom_model.dart';

class SymptomsAnalysisScreen extends StatefulWidget {
  const SymptomsAnalysisScreen({super.key});

  @override
  State<SymptomsAnalysisScreen> createState() => _SymptomsAnalysisScreenState();
}

class _SymptomsAnalysisScreenState extends State<SymptomsAnalysisScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل الأعراض'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SymptomsProvider>().reset();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Consumer<SymptomsProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Stepper
              _buildStepper(provider, isDark),

              // Content
              Expanded(
                child: _buildStepContent(provider, isDark),
              ),

              // Navigation Buttons
              if (provider.currentStep < 2)
                _buildNavigationButtons(provider, isDark),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepper(SymptomsProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildStepIndicator(0, 'اختيار الأعراض', provider.currentStep >= 0,
              provider.currentStep > 0, isDark),
          _buildStepLine(provider.currentStep > 0, isDark),
          _buildStepIndicator(1, 'معلومات إضافية', provider.currentStep >= 1,
              provider.currentStep > 1, isDark),
          _buildStepLine(provider.currentStep > 1, isDark),
          _buildStepIndicator(
              2, 'النتيجة', provider.currentStep >= 2, false, isDark),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
      int step, String label, bool isActive, bool isCompleted, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient:
                  isActive || isCompleted ? AppColors.primaryGradient : null,
              color: !isActive && !isCompleted
                  ? (isDark ? AppColors.cardDark : AppColors.cardLight)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '${step + 1}',
                      style: TextStyle(
                        color: isActive || isCompleted
                            ? Colors.white
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isActive
                  ? AppColors.primaryBlue
                  : (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isCompleted, bool isDark) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          gradient: isCompleted ? AppColors.primaryGradient : null,
          color: !isCompleted
              ? (isDark ? AppColors.cardDark : AppColors.cardLight)
              : null,
        ),
      ),
    );
  }

  Widget _buildStepContent(SymptomsProvider provider, bool isDark) {
    switch (provider.currentStep) {
      case 0:
        return _buildSymptomSelection(provider, isDark);
      case 1:
        return _buildAdditionalInfo(provider, isDark);
      case 2:
        return _buildResults(provider, isDark);
      default:
        return const SizedBox();
    }
  }

  Widget _buildSymptomSelection(SymptomsProvider provider, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر الأعراض التي تعاني منها:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: provider.allSymptoms.map((symptom) {
              final isSelected = provider.selectedSymptoms.contains(symptom);
              return _buildSymptomChip(symptom, isSelected, () {
                provider.toggleSymptom(symptom);
              }, isDark)
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(delay: 50.ms);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomChip(
      Symptom symptom, bool isSelected, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: !isSelected
              ? (isDark ? AppColors.cardDark : AppColors.cardLight)
              : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.cardDark : AppColors.cardLight),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(symptom.iconEmoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              symptom.nameAr,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(SymptomsProvider provider, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات إضافية:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'أضف أي تفاصيل إضافية عن حالتك:',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الأعراض المختارة:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: provider.selectedSymptoms.map((symptom) {
                    return Chip(
                      label: Text('${symptom.iconEmoji} ${symptom.nameAr}'),
                      backgroundColor: isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _notesController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'مثال: الأعراض بدأت منذ يومين، الألم خفيف...',
              filled: true,
              fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) => provider.setAdditionalInfo(value),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(SymptomsProvider provider, bool isDark) {
    if (provider.isAnalyzing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'جارٍ تحليل الأعراض بالذكاء الاصطناعي...',
              style: TextStyle(
                fontSize: 16,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'نتائج التحليل الذكي:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: provider.currentModel == 'grok'
                      ? AppColors.accentTeal.withOpacity(0.2)
                      : AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      provider.currentModel == 'grok'
                          ? Icons.auto_awesome
                          : Icons.lightbulb_outline,
                      size: 16,
                      color: provider.currentModel == 'grok'
                          ? AppColors.accentTeal
                          : AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      provider.currentModel == 'grok' ? 'Grok AI' : 'Gemini AI',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: provider.currentModel == 'grok'
                            ? AppColors.accentTeal
                            : AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.info, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    provider.disclaimer.isNotEmpty
                        ? provider.disclaimer
                        : 'هذه النتائج استرشادية فقط. يُرجى استشارة الطبيب للتشخيص الدقيق.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // AI Analysis Section
          if (provider.aiAnalysis.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.psychology_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'التحليل الطبي',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.aiAnalysis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
            const SizedBox(height: 16),
          ],

          // Possible Diseases
          if (provider.possibleDiseases.isEmpty)
            Center(
              child: Text(
                'لم يتم العثور على تطابقات. يُرجى استشارة طبيب.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
            )
          else ...[
            Text(
              'الأمراض المحتملة:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),
            ...provider.possibleDiseases.map((disease) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(disease.iconEmoji,
                            style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            disease.nameAr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getSeverityColor(disease.severity)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getSeverityText(disease.severity),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getSeverityColor(disease.severity),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      disease.descriptionAr,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/disease-detail',
                          arguments: disease,
                        );
                      },
                      child: const Text('عرض التفاصيل'),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
            }),
          ],

          // Home Care Tips
          if (provider.homeCareTips.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.success, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home_outlined, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text(
                        'نصائح للعناية المنزلية:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...provider.homeCareTips.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],

          // When to See Doctor
          if (provider.whenToSeeDoctor.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.warning, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_hospital,
                          color: AppColors.warning),
                      const SizedBox(width: 8),
                      Text(
                        'متى يجب مراجعة الطبيب:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    provider.whenToSeeDoctor,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(SymptomsProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (provider.currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: provider.previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('السابق'),
              ),
            ),
          if (provider.currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (provider.currentStep == 0 &&
                    provider.selectedSymptoms.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('يرجى اختيار عرض واحد على الأقل')),
                  );
                  return;
                }

                if (provider.currentStep == 1) {
                  provider.analyzeSymptoms();
                } else {
                  provider.nextStep();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(provider.currentStep == 1 ? 'تحليل' : 'التالي'),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'low':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'high':
        return AppColors.error;
      default:
        return AppColors.info;
    }
  }

  String _getSeverityText(String severity) {
    switch (severity) {
      case 'low':
        return 'خفيف';
      case 'medium':
        return 'متوسط';
      case 'high':
        return 'شديد';
      default:
        return 'غير محدد';
    }
  }
}
