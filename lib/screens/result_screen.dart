import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/gamified_nav_bar.dart';
import '../widgets/gamified_top_bar.dart';
import '../widgets/score_summary_card.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DynamicAppBackground(
      bottomNavigationBar: GamifiedNavBar(
        selectedIndex: 2,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (index == 1) {
            quiz.startQuiz();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const QuizScreen()),
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
                const SizedBox(height: 8),

                // Stats Header with Peeking Mascot
                _buildStatsHeader(isDark),
                const SizedBox(height: 14),

                // Dynamic Score Summary & Brain Rot Cured Metric Card
                ScoreSummaryCard(
                  score: quiz.score,
                  total: quiz.totalQuestions,
                  brainRotCured: quiz.brainRotCuredPercentage,
                  achievementTier: quiz.achievementTier,
                  userName: quiz.userName,
                ),
                const SizedBox(height: 16),

                // Top 3 Stat Cards in a Row
                _buildTopStatRow(quiz, isDark),
                const SizedBox(height: 20),

                // Progress Over Time Bar Chart Card
                _buildProgressChartCard(isDark),
                const SizedBox(height: 20),

                // Skill Breakdown Section
                _buildSectionTitle(
                  title: 'Skill breakdown',
                  actionLabel: 'View all >',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildSkillBreakdown(isDark),
                const SizedBox(height: 20),

                // Time Spent & Daily Goal Dual Cards
                Row(
                  children: [
                    Expanded(child: _buildTimeSpentCard(isDark)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDailyGoalCard(isDark)),
                  ],
                ),
                const SizedBox(height: 20),

                // "You're on fire!" Streak Celebration Banner
                _buildStreakBanner(isDark),
                const SizedBox(height: 24),

                // Action Buttons: Retry Quiz & Back to Learn
                Row(
                  children: [
                    Expanded(
                      child: Custom3DButton(
                        text: 'Back to Home',
                        variant: ButtonVariant.outline,
                        height: 50,
                        fontSize: 14,
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Custom3DButton(
                        text: 'Retry Quiz',
                        icon: Icons.replay_rounded,
                        height: 50,
                        fontSize: 14,
                        onPressed: () {
                          quiz.retryQuiz();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const QuizScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                children: const [
                  TextSpan(text: 'Your '),
                  TextSpan(
                    text: 'Stats',
                    style: TextStyle(color: AppColors.accent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Small steps. Big progress!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
          ],
        ),
        Image.asset(
          'assets/mascots/mascot_celebrate.png',
          height: 85,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.celebration_rounded,
            size: 60,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildTopStatRow(QuizProvider quiz, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniStatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.flame,
            title: 'Current streak',
            value: '${quiz.streakDays} days',
            subtitle: 'Longest: 56 days',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniStatCard(
            icon: Icons.bolt_rounded,
            iconColor: AppColors.primary,
            title: 'Total quizzes',
            value: '127',
            subtitle: 'Completed',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniStatCard(
            icon: Icons.diamond_rounded,
            iconColor: AppColors.gem,
            title: 'Average score',
            value: '${quiz.scorePercentage > 0 ? quiz.scorePercentage : 87}%',
            subtitle: 'Last 4 weeks',
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChartCard(bool isDark) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const percentages = [68, 72, 85, 90, 88, 93, 87];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 12,
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
              Text(
                'Progress over time',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF263346) : const Color(0xFFF0F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      'Last 4 weeks',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Bar Chart with Axis Labels
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('100%', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  SizedBox(height: 18),
                  Text('75%', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  SizedBox(height: 18),
                  Text('50%', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  SizedBox(height: 18),
                  Text('25%', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  SizedBox(height: 18),
                  Text('0%', style: TextStyle(fontSize: 9, color: Colors.grey)),
                ],
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    final pct = percentages[index];
                    final double barHeight = (pct / 100) * 110;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$pct%',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 26,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF38BDF8),
                                Color(0xFF0284C7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    required String actionLabel,
    required bool isDark,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        Text(
          actionLabel,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillBreakdown(bool isDark) {
    return Column(
      children: [
        _buildSkillRow(
          title: 'Flutter',
          count: '8 / 12',
          percent: '67%',
          ratio: 0.67,
          icon: Icons.flutter_dash,
          color: AppColors.primary,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _buildSkillRow(
          title: 'Dart',
          count: '5 / 10',
          percent: '50%',
          ratio: 0.50,
          icon: Icons.code_rounded,
          color: AppColors.purple,
          isDark: isDark,
        ),
        const SizedBox(height: 8),
        _buildSkillRow(
          title: 'Mobile UX',
          count: '3 / 8',
          percent: '38%',
          ratio: 0.38,
          icon: Icons.smartphone_rounded,
          color: AppColors.accent,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildSkillRow({
    required String title,
    required String count,
    required String percent,
    required double ratio,
    required IconData icon,
    required Color color,
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
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Row(
                      children: [
                        Text(
                          '$count  ',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                        Text(
                          percent,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 6,
                    backgroundColor: isDark ? const Color(0xFF263346) : const Color(0xFFEDF3F7),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSpentCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time spent learning',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '4h 28m',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          Text(
            'This week',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.arrow_upward_rounded, size: 12, color: AppColors.success),
                  SizedBox(width: 2),
                  Text(
                    '+12%',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE8F3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.alarm_rounded, size: 20, color: AppColors.accent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily goal',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 6,
                    backgroundColor: isDark ? const Color(0xFF263346) : const Color(0xFFFDE8F3),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '3 / 3',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'tasks',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Goal completed! 🎉',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2D1830), const Color(0xFF20162A)]
              : [const Color(0xFFFCE6F3), const Color(0xFFFCEBF6)],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/mascots/mascot_celebrate.png',
            height: 60,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(Icons.star_rounded, size: 40, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You\'re on fire!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'You\'ve kept your streak for 6 weeks in a row.',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
