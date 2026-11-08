import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';

enum OptionVisualState {
  defaultState,
  selected,
  correct,
  incorrect,
}

class OptionCard extends StatelessWidget {
  final String label;
  final String text;
  final OptionVisualState visualState;
  final VoidCallback? onTap;

  const OptionCard({
    super.key,
    required this.label,
    required this.text,
    this.visualState = OptionVisualState.defaultState,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    Color borderColor;
    Color badgeBg;
    Color badgeTextColor;
    Widget? trailingIcon;

    switch (visualState) {
      case OptionVisualState.selected:
      case OptionVisualState.correct:
        backgroundColor = isDark ? const Color(0xFF2E1C2B) : const Color(0xFFFDE8F3);
        borderColor = AppColors.accent;
        badgeBg = AppColors.accent;
        badgeTextColor = Colors.white;
        trailingIcon = Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        );
        break;

      case OptionVisualState.incorrect:
        backgroundColor = isDark ? const Color(0xFF331B21) : const Color(0xFFFFEEEE);
        borderColor = Colors.redAccent;
        badgeBg = Colors.redAccent;
        badgeTextColor = Colors.white;
        trailingIcon = const Icon(Icons.close_rounded, size: 20, color: Colors.redAccent);
        break;

      case OptionVisualState.defaultState:
        backgroundColor = isDark ? AppColors.cardDark : AppColors.cardLight;
        borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight;
        badgeBg = isDark ? const Color(0xFF263346) : const Color(0xFFE5EEF5);
        badgeTextColor = isDark ? const Color(0xFF9FB2CA) : const Color(0xFF7B91A7);
        trailingIcon = null;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: AppColors.accent.withValues(alpha: 0.12),
          highlightColor: AppColors.accent.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: visualState == OptionVisualState.defaultState ? 1.5 : 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: badgeTextColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 10),
                  trailingIcon,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
