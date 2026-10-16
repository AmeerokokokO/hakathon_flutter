import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme/app_colors.dart';
import '../../../data/repositories/symptoms_repository.dart';
import '../../../data/models/disease_model.dart';

class DiseaseListScreen extends StatefulWidget {
  const DiseaseListScreen({super.key});

  @override
  State<DiseaseListScreen> createState() => _DiseaseListScreenState();
}

class _DiseaseListScreenState extends State<DiseaseListScreen> {
  final DiseaseRepository _repository = DiseaseRepository();
  final TextEditingController _searchController = TextEditingController();
  List<Disease> _diseases = [];
  List<Disease> _filteredDiseases = [];

  @override
  void initState() {
    super.initState();
    _diseases = _repository.getAllDiseases();
    _filteredDiseases = _diseases;
    _searchController.addListener(_filterDiseases);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDiseases() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _filteredDiseases = _diseases;
      });
    } else {
      setState(() {
        _filteredDiseases = _repository.searchDiseases(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأمراض'),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن مرض...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Disease List
          Expanded(
            child: _filteredDiseases.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد نتائج',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredDiseases.length,
                    itemBuilder: (context, index) {
                      final disease = _filteredDiseases[index];
                      return _buildDiseaseCard(disease, isDark)
                          .animate()
                          .fadeIn(delay: (index * 50).ms, duration: 400.ms)
                          .slideX(begin: 0.2, end: 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(Disease disease, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/disease-detail',
          arguments: disease,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'disease-${disease.id}',
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: _getSeverityGradient(disease.severity),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    disease.iconEmoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease.nameAr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    disease.descriptionAr,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getSeverityColor(disease.severity)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getSeverityText(disease.severity),
                          style: TextStyle(
                            fontSize: 11,
                            color: _getSeverityColor(disease.severity),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        disease.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondaryLight,
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getSeverityGradient(String severity) {
    switch (severity) {
      case 'low':
        return const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        );
      case 'medium':
        return const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
        );
      case 'high':
        return const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        );
      default:
        return AppColors.primaryGradient;
    }
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
