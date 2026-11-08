import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question_model.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/app_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/gamified_nav_bar.dart';
import '../widgets/gamified_top_bar.dart';
import '../widgets/option_card.dart';
import '../widgets/progress_header.dart';
import 'home_screen.dart';
import 'result_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQ = quiz.currentQuestion;

    return DynamicAppBackground(
      bottomNavigationBar: GamifiedNavBar(
        selectedIndex: 1,
        onItemSelected: (index) {
          if (index == 0) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
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
                const SizedBox(height: 10),

                // Active Mascot Header Banner
                _buildMascotHeader(quiz, isDark),
                const SizedBox(height: 16),

                // Progress Header (Capsule progress + timer)
                ProgressHeader(
                  currentStep: quiz.currentIndex + 1,
                  totalSteps: quiz.totalQuestions,
                  formattedTime: quiz.formattedTimer,
                ),
                const SizedBox(height: 18),

                // Dynamic Question Text
                Text(
                  currentQ.questionText,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose the best answer.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 14),

                // Option Cards A, B, C, D
                ...List.generate(currentQ.options.length, (index) {
                  const optionLetters = ['A', 'B', 'C', 'D'];
                  final letter = index < optionLetters.length ? optionLetters[index] : '${index + 1}';
                  final isSelected = quiz.currentSelectedOption == index;
                  final isSubmitted = quiz.isAnswerSubmitted;
                  final isCorrectAnswer = index == currentQ.correctIndex;

                  OptionVisualState visualState = OptionVisualState.defaultState;
                  if (isSubmitted) {
                    if (isSelected) {
                      visualState = isCorrectAnswer
                          ? OptionVisualState.correct
                          : OptionVisualState.incorrect;
                    } else if (isCorrectAnswer) {
                      visualState = OptionVisualState.correct;
                    }
                  } else if (isSelected) {
                    visualState = OptionVisualState.selected;
                  }

                  return OptionCard(
                    label: letter,
                    text: currentQ.options[index],
                    visualState: visualState,
                    onTap: isSubmitted ? null : () => quiz.selectOption(index),
                  );
                }),
                const SizedBox(height: 16),

                // Dynamic Feedback Card (When an answer is chosen)
                if (quiz.isAnswerSubmitted) ...[
                  _buildFeedbackBanner(context, quiz, currentQ, isDark),
                  const SizedBox(height: 16),
                ],

                // Action Buttons: Explanation & Next Question
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Custom3DButton(
                        text: 'Explanation',
                        variant: ButtonVariant.outline,
                        height: 48,
                        fontSize: 13,
                        onPressed: () => _showExplanationSheet(context, currentQ, isDark),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Custom3DButton(
                        text: quiz.currentIndex == quiz.totalQuestions - 1
                            ? 'Finish Quiz 🎉'
                            : 'Next question >',
                        height: 48,
                        fontSize: 14,
                        onPressed: () {
                          if (!quiz.isAnswerSubmitted) {
                            quiz.selectOption(-1);
                          }
                          if (quiz.currentIndex == quiz.totalQuestions - 1) {
                            quiz.nextQuestion();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const ResultScreen()),
                            );
                          } else {
                            quiz.nextQuestion();
                          }
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

  Widget _buildMascotHeader(QuizProvider quiz, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
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
                            color: isDark ? const Color(0xFF281E38) : const Color(0xFFF3EDFD),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.code_rounded, size: 14, color: AppColors.purple),
                              const SizedBox(width: 4),
                              Text(
                                '${quiz.selectedCategory.label} Basics',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Quiz time!',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Test what you\'ve learned\nand keep the streak going.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Image.asset(
                      'assets/mascots/mascot_quiz.png',
                      fit: BoxFit.contain,
                      height: 130,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.school_rounded,
                        size: 80,
                        color: AppColors.accent,
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

  Widget _buildFeedbackBanner(
    BuildContext context,
    QuizProvider quiz,
    Question question,
    bool isDark,
  ) {
    final isCorrect = quiz.isCurrentAnswerCorrect;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? (isDark ? const Color(0xFF2B1D2C) : const Color(0xFFFDE8F3))
            : (isDark ? const Color(0xFF321E23) : const Color(0xFFFFEEEE)),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isCorrect
              ? AppColors.accent.withValues(alpha: 0.4)
              : Colors.redAccent.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.lightbulb_rounded : Icons.info_outline_rounded,
                      size: 20,
                      color: isCorrect ? AppColors.accent : Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isCorrect ? 'Good choice!' : 'Keep learning!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isCorrect ? AppColors.accent : Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  question.explanation,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Image.asset(
            'assets/mascots/mascot_celebrate.png',
            height: 75,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(Icons.thumb_up_alt_rounded, size: 50, color: AppColors.accent),
          ),
        ],
      ),
    );
  }

  void _showExplanationSheet(BuildContext context, Question question, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school_rounded, color: AppColors.accent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Deep Dive Explanation',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                question.explanation,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  height: 1.45,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF16202F) : const Color(0xFFE8F6FB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Correct Answer: ${question.options[question.correctIndex]}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Custom3DButton(
                text: 'Got it!',
                height: 46,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}
