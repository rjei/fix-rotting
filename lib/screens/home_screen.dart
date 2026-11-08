import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question_model.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/gamified_nav_bar.dart';
import '../widgets/gamified_top_bar.dart';
import 'quiz_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DynamicAppBackground(
      bottomNavigationBar: GamifiedNavBar(
        selectedIndex: 0,
        onItemSelected: (index) {
          if (index == 1) {
            quiz.startQuiz();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const QuizScreen()),
            );
          } else if (index == 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ResultScreen()),
            );
          }
        },
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                const GamifiedTopBar(),
                const SizedBox(height: 12),

                // Gamified User Profile Greeting
                _buildUserGreeting(context, quiz, isDark),
                const SizedBox(height: 14),

                // Hero Banner Card: "Keep your Flutter skills sharp!"
                _buildHeroBanner(context, quiz, isDark),
                const SizedBox(height: 22),

                // Learning Tracks Section
                _buildSectionHeader(
                  context,
                  title: 'Learning tracks',
                  actionLabel: 'View all >',
                  onActionTap: () {},
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildLearningTracks(context, quiz, isDark),
                const SizedBox(height: 20),

                // Streak Weekly Tracker Card
                _buildStreakCard(quiz, isDark),
                const SizedBox(height: 20),

                // "Next up" Card
                _buildSectionHeader(
                  context,
                  title: 'Next up',
                  actionLabel: 'View all >',
                  onActionTap: () {},
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildNextUpCard(context, quiz, isDark),
                const SizedBox(height: 20),

                // Recent Activity Section
                Text(
                  'Recent activity',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRecentActivityList(isDark),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserGreeting(BuildContext context, QuizProvider quiz, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardDark.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                Text(
                  quiz.userName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit Name',
            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
            onPressed: () => _showEditNameDialog(context, quiz),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, QuizProvider quiz) {
    final controller = TextEditingController(text: quiz.userName);
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: const Text(
            'Change Player Name',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              filled: true,
              fillColor: isDark ? const Color(0xFF16202F) : const Color(0xFFF3F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            Custom3DButton(
              text: 'Save',
              height: 42,
              fontSize: 13,
              onPressed: () {
                quiz.setUserName(controller.text);
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeroBanner(BuildContext context, QuizProvider quiz, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              bottom: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDE8F3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "TODAY'S TASKS",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accent,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              height: 1.25,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            children: const [
                              TextSpan(text: 'Keep your\n'),
                              TextSpan(
                                text: 'Flutter ',
                                style: TextStyle(color: AppColors.accent),
                              ),
                              TextSpan(text: 'skills\nsharp!'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '3 quick challenges • 12 min',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Custom3DButton(
                          text: 'Start today',
                          icon: Icons.play_arrow_rounded,
                          height: 48,
                          fontSize: 14,
                          onPressed: () {
                            quiz.startQuiz(category: TrackCategory.flutter);
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const QuizScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Image.asset(
                      'assets/mascots/mascot_welcome.png',
                      fit: BoxFit.contain,
                      height: 160,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.flutter_dash,
                        size: 90,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String actionLabel,
    required VoidCallback onActionTap,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLearningTracks(BuildContext context, QuizProvider quiz, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildTrackCard(
            title: 'Flutter',
            count: '8 / 12',
            progress: 8 / 12,
            icon: Icons.flutter_dash,
            color: AppColors.primary,
            isSelected: quiz.selectedCategory == TrackCategory.flutter,
            isDark: isDark,
            onTap: () {
              quiz.selectCategory(TrackCategory.flutter);
            },
          ),
          const SizedBox(width: 12),
          _buildTrackCard(
            title: 'Dart',
            count: '5 / 10',
            progress: 5 / 10,
            icon: Icons.code_rounded,
            color: AppColors.purple,
            isSelected: quiz.selectedCategory == TrackCategory.dart,
            isDark: isDark,
            onTap: () {
              quiz.selectCategory(TrackCategory.dart);
            },
          ),
          const SizedBox(width: 12),
          _buildTrackCard(
            title: 'Mobile UX',
            count: '3 / 8',
            progress: 3 / 8,
            icon: Icons.smartphone_rounded,
            color: AppColors.accent,
            isSelected: quiz.selectedCategory == TrackCategory.mobileUx,
            isDark: isDark,
            onTap: () {
              quiz.selectCategory(TrackCategory.mobileUx);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrackCard({
    required String title,
    required String count,
    required double progress,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight),
            width: isSelected ? 2 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: isDark ? const Color(0xFF263346) : const Color(0xFFE9F2F7),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(QuizProvider quiz, bool isDark) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFECEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: AppColors.flame,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current streak',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${quiz.streakDays} days',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('✨', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  Text(
                    'Longest streak: 56 days',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final isCompleted = index < 6;
              return Column(
                children: [
                  Text(
                    days[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppColors.accent
                          : (isDark ? const Color(0xFF263346) : const Color(0xFFF1F5F8)),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, size: 13, color: Colors.white)
                        : null,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNextUpCard(BuildContext context, QuizProvider quiz, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF261D32), AppColors.cardDark]
              : [const Color(0xFFFDF0F8), Colors.white],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : const Color(0xFFFADAEB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 12, color: AppColors.accent),
                      SizedBox(width: 2),
                      Text(
                        'Quiz',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Widget Life Cycle',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Medium • 6 questions',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 14),
                Custom3DButton(
                  text: 'Continue',
                  icon: Icons.play_arrow_rounded,
                  height: 42,
                  fontSize: 13,
                  onPressed: () {
                    quiz.startQuiz(category: TrackCategory.widgetLifecycle);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const QuizScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.layers_rounded,
              size: 42,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityList(bool isDark) {
    return Column(
      children: [
        _buildActivityItem(
          title: 'State Management',
          subtitle: 'Completed • 10 min',
          date: 'Apr 25, 2025',
          icon: Icons.check_circle_rounded,
          iconColor: AppColors.success,
          iconBg: isDark ? const Color(0xFF1B3028) : AppColors.successBg,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _buildActivityItem(
          title: 'Flutter Basics',
          subtitle: 'Quiz • 8/10',
          date: 'Apr 24, 2025',
          icon: Icons.code_rounded,
          iconColor: AppColors.purple,
          iconBg: isDark ? const Color(0xFF2D2340) : const Color(0xFFF3EDFD),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String date,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$date  >',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }
}
