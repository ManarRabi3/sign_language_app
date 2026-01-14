import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/feature_card.dart';
import '../widgets/animated_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتحركة
          const AnimatedBackground(),

          // المحتوى الأساسي
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // الهيدر: شعار + عنوان + شعار فرعي
                  _buildHeader(),

                  const SizedBox(height: 40),

                  // شبكة المميزات
                  Expanded(child: _buildFeaturesGrid()),

                  // الفوتر
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== الهيدر =====================
  Widget _buildHeader() {
    return Column(
      children: [
        // شعار التطبيق
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.sign_language,
            size: 50,
            color: Colors.white,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(delay: 200.ms, curve: Curves.elasticOut),

        const SizedBox(height: 24),

        // عنوان التطبيق
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.grey900,
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 8),

        // الشعار الفرعي
        Text(
          AppStrings.appTagline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.grey500,
          ),
        )
            .animate()
            .fadeIn(delay: 600.ms),
      ],
    );
  }

  // ===================== شبكة المميزات =====================
  Widget _buildFeaturesGrid() {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // ميزة Sign to Text
        FeatureCard(
          title: AppStrings.signToText,
          subtitle: AppStrings.signToTextDesc,
          icon: Icons.camera_alt_rounded,
          gradient: AppColors.signToTextGradient,
          onTap: () => Navigator.pushNamed(context, '/sign-to-text'),
        )
            .animate()
            .fadeIn(delay: 500.ms)
            .slideX(begin: -0.2, end: 0),

        // ميزة Text to Sign
        FeatureCard(
          title: AppStrings.textToSign,
          subtitle: AppStrings.textToSignDesc,
          icon: Icons.accessibility_new_rounded,
          gradient: AppColors.textToSignGradient,
          onTap: () => Navigator.pushNamed(context, '/text-to-sign'),
        )
            .animate()
            .fadeIn(delay: 600.ms)
            .slideX(begin: 0.2, end: 0),

        // ميزة Dictionary
        FeatureCard(
          title: AppStrings.dictionary,
          subtitle: AppStrings.dictionaryDesc,
          icon: Icons.menu_book_rounded,
          gradient: AppColors.dictionaryGradient,
          onTap: () => Navigator.pushNamed(context, '/dictionary'),
        )
            .animate()
            .fadeIn(delay: 700.ms)
            .slideY(begin: 0.2, end: 0),

        // ميزة Settings
        FeatureCard(
          title: AppStrings.settings,
          subtitle: AppStrings.settingsDesc,
          icon: Icons.settings_rounded,
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          onTap: () => Navigator.pushNamed(context, '/settings'),
        )
            .animate()
            .fadeIn(delay: 800.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  // ===================== الفوتر =====================
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: Colors.red[400], size: 18),
          const SizedBox(width: 8),
          Text(
            ' صنع بحب فى مصرEG',
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1000.ms);
  }
}
