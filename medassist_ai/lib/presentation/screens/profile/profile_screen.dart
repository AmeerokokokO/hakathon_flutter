import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 50,
                          color: AppColors.primaryBlue,
                        ),
                      ).animate().scale(delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: 15),
                      const Text(
                        'مستخدم MedAssist',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Health Stats
                  Text(
                    'إحصائياتي الصحية',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          '12',
                          'محادثات',
                          Icons.chat_bubble_outline_rounded,
                          AppColors.primaryGradient,
                          isDark,
                          600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          '5',
                          'تحليلات',
                          Icons.analytics_outlined,
                          AppColors.secondaryGradient,
                          isDark,
                          700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Settings
                  Text(
                    'الإعدادات',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
                  const SizedBox(height: 15),

                  _buildSettingTile(
                    'إعدادات التطبيق',
                    'تخصيص API والإعدادات الأخرى',
                    Icons.settings_outlined,
                    () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    isDark,
                    900,
                  ),

                  const SizedBox(height: 12),

                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return _buildSwitchTile(
                        'الوضع الداكن',
                        'تفعيل/تعطيل الوضع الداكن',
                        Icons.dark_mode_outlined,
                        themeProvider.isDarkMode,
                        (value) {
                          themeProvider.toggleTheme();
                        },
                        isDark,
                        1000,
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  _buildSettingTile(
                    'سجل المحادثات',
                    'عرض سجل جميع المحادثات',
                    Icons.history_rounded,
                    () {
                      // TODO: Implement chat history
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('قريباً...')),
                      );
                    },
                    isDark,
                    1100,
                  ),

                  const SizedBox(height: 30),

                  // About
                  Text(
                    'حول',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
                  const SizedBox(height: 15),

                  _buildSettingTile(
                    'عن التطبيق',
                    'الإصدار 1.0.0',
                    Icons.info_outline_rounded,
                    () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'MedAssist AI',
                        applicationVersion: '1.0.0',
                        applicationIcon: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.medical_services_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        children: [
                          const Text(
                            'مساعدك الطبي الذكي\n\nتطبيق يوفر معلومات طبية موثوقة ومساعدة ذكية للتشخيص الأولي.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                    isDark,
                    1300,
                  ),

                  const SizedBox(height: 12),

                  _buildSettingTile(
                    'الشروط والأحكام',
                    'سياسة الخصوصية والاستخدام',
                    Icons.description_outlined,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('قريباً...')),
                      );
                    },
                    isDark,
                    1400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon,
      Gradient gradient, bool isDark, int delayMs) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delayMs.ms, duration: 400.ms)
        .scale(delay: delayMs.ms);
  }

  Widget _buildSettingTile(String title, String subtitle, IconData icon,
      VoidCallback onTap, bool isDark, int delayMs) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
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
    )
        .animate()
        .fadeIn(delay: delayMs.ms, duration: 400.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon,
      bool value, Function(bool) onChanged, bool isDark, int delayMs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryBlue,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delayMs.ms, duration: 400.ms)
        .slideX(begin: 0.2, end: 0);
  }
}
