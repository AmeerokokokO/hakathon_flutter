import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../services/health_tips_service.dart';
import '../../../providers/theme_provider.dart';
import 'widgets/medical_card.dart';
import 'widgets/health_tip_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HealthTipsService _tipsService = HealthTipsService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dailyTips = _tipsService.getDailyTips(count: 5);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مرحباً بك 👋',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'كيف يمكنني مساعدتك اليوم؟',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    Consumer<ThemeProvider>(
                      builder: (context, themeProvider, _) {
                        return IconButton(
                          onPressed: () => themeProvider.toggleTheme(),
                          icon: Icon(
                            themeProvider.isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
            ),

            // Quick Actions Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: MedicalCard(
                            title: 'دردشة مع AI',
                            subtitle: 'استشر المساعد الذكي',
                            icon: Icons.chat_bubble_rounded,
                            gradient: AppColors.primaryGradient,
                            onTap: () => Navigator.pushNamed(context, '/chat'),
                          )
                              .animate()
                              .fadeIn(delay: 100.ms, duration: 400.ms)
                              .slideX(begin: -0.2, end: 0),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: MedicalCard(
                            title: 'تحليل الأعراض',
                            subtitle: 'افحص أعراضك الآن',
                            icon: Icons.assessment_rounded,
                            gradient: AppColors.secondaryGradient,
                            onTap: () =>
                                Navigator.pushNamed(context, '/symptoms'),
                          )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 400.ms)
                              .slideX(begin: 0.2, end: 0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: MedicalCard(
                            title: 'الأمراض',
                            subtitle: 'تصفح المعلومات الطبية',
                            icon: Icons.local_hospital_rounded,
                            gradient: AppColors.accentGradient,
                            onTap: () =>
                                Navigator.pushNamed(context, '/diseases'),
                          )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 400.ms)
                              .slideX(begin: -0.2, end: 0),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: MedicalCard(
                            title: 'البروفايل',
                            subtitle: 'معلوماتك الصحية',
                            icon: Icons.person_rounded,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, '/profile'),
                          )
                              .animate()
                              .fadeIn(delay: 400.ms, duration: 400.ms)
                              .slideX(begin: 0.2, end: 0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Daily Health Tips Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                child: Text(
                  'نصائح صحية يومية 💡',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  scrollDirection: Axis.horizontal,
                  itemCount: dailyTips.length,
                  itemBuilder: (context, index) {
                    return HealthTipCard(tip: dailyTips[index])
                        .animate()
                        .fadeIn(delay: (600 + index * 100).ms, duration: 400.ms)
                        .slideX(begin: 0.3, end: 0);
                  },
                ),
              ),
            ),

            // Common Diseases Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 20, left: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'أمراض شائعة 🏥',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/diseases'),
                      child: const Text('عرض الكل'),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildDiseaseChip('🤧 نزلة البرد', isDark)
                        .animate()
                        .fadeIn(delay: 900.ms, duration: 400.ms)
                        .scale(delay: 900.ms),
                    _buildDiseaseChip('🤒 الإنفلونزا', isDark)
                        .animate()
                        .fadeIn(delay: 950.ms, duration: 400.ms)
                        .scale(delay: 950.ms),
                    _buildDiseaseChip('🤕 الصداع النصفي', isDark)
                        .animate()
                        .fadeIn(delay: 1000.ms, duration: 400.ms)
                        .scale(delay: 1000.ms),
                    _buildDiseaseChip('❤️ ارتفاع ضغط الدم', isDark)
                        .animate()
                        .fadeIn(delay: 1050.ms, duration: 400.ms)
                        .scale(delay: 1050.ms),
                    _buildDiseaseChip('🫁 الربو', isDark)
                        .animate()
                        .fadeIn(delay: 1100.ms, duration: 400.ms)
                        .scale(delay: 1100.ms),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseChip(String label, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/diseases'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ),
    );
  }
}
